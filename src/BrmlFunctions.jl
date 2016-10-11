
module BrmlFunctions
# General helper functions:

#VERSION < v"0.4-" && using Docile
#@docstrings

import Base: vec, findmax

# Type Unions:
export IntOrIntArray
IntOrIntArray=Union{Integer,Array{Integer},Array{}} # include also the ranges and vectors


export vec
@doc """
 Creates a vector with 1 element of value v
""" ->
function vec(v::Integer)
    return vec([v])
end

export maxarray
@doc """
 Finds the largest non-zero value of matrix **`A`**
""" ->
function maxarray(A)
    p,q,r=findnz(A)
    return maximum(r)
end

export SparseIntMatrix
@doc """
 Initialises a new matrix of size **M x N**

* `M`:     number of rows
* `N`:     number of columns
""" ->
function SparseIntMatrix(M,N)
    #return Int(spzeros(M,N))
    return round(Int64,spzeros(M,N))
end

export fillmatrix!
@doc """
 Initialises a subarray of **`A`** with value **`val`**

* `A`:         array to fill
* `indsi`:     vector/range of row indeces
* `indsj`:     vector/range of column indeces
* `val`:       value to fill with the elements
""" ->
function  fillmatrix!(A,indsi,indsj,val)
    for i=indsi
        for j=indsj
            A[i,j]=val
        end
    end
    return A
end

export states
@doc """
 Enumerates all states given the number of states of each variable from a given set similar to MATLAB _ind2subv_

* `ns`:    vector with the total number of states for each variable
""" ->
function states(ns)
    # enumerate all states eg states([2 2 3]) (like ind2subv.m)
    # first index changes the most (like matlab)
    #ns=fliplr(ns)
    ns=flipdim(ns,2)
    n=length(ns)
    nstates=prod(vec(ns))
    c=cumprod(vec(ns[end:-1:1]))
    c=vcat(1,c[1:end-1])
    s=Array(Int64,nstates,n)
    for i=1:nstates
        tmp=i-1
        for j=n:-1:1
            s[i,n+1-j]=floor(tmp/c[j])
            tmp=tmp-s[i,n+1-j]*c[j]
        end
    end
    #return fliplr(s.+1)
    return flipdim(s.+1,2)
end

export standardise
@doc """
 Transforms an one-dimensional array **`A`** of numerical values into a column vector,
  otherwise it leaves the input unchanged
""" ->
function standardise{T<:Number}(A::Array{T,})
    # If the array is a vector, make this a column vector, otherwise leave unchanged
    if isavector(A)
        A=vec(A)
    end
    return A
end

export mysize
@doc """
 Returns the size for each dimension of a vector or matrix

* `a`:     vector or matrix to analyse
""" ->
function mysize(a)
    a=standardise(a)
    s=size(a)
    if isavector(a)
        sz=s[1]
    else
        sz=s[1:end]
    end
    return sz
end

export memberinds
@doc """
 Returns a vector mapping the indices of **`x`** and **`y`** for which the corresponding elements have the same value

* `x`:     item to compare
* `y`:     item to compare
""" ->
function memberinds(x,y)
    ind=zeros(Int64,length(x),1)
    for i=1:length(x)
        for j=1:length(y)
            if y[j]==x[i]
                ind[i]=j;
            end
        end
    end
    return ind
end

export myvcat
@doc """
 Wrapper for standard **`vcat`** used for
 backward compatibility from porting the MATLAB version of BRML code
""" ->
function myvcat(x,y)
    if length(x)==0
        return y
    end

    if length(y)==0
        return x
    end

    return vcat(x,y)
end

export isavector
@doc """
 Verifies if matrix **`A`** has one of the dimensions of size **1**
""" ->
function isavector(A)

    if length(size(A))>2
        return false
    elseif  (size(A,1)==1 && size(A,2)>1) || (size(A,2)==1 && size(A,1)>1)
        return true
    else
        return false
    end

end

export numstates
@doc """
 Returns the number of elements of matrix **`A`**
""" ->
function numstates(A)
    if isavector(A)
        n=prod(size(A));
    else
        n=size(A);
    end
    return n
end

export replace
@doc """
 Finds the elements having value **`f`** in matrix **`A`** and replaces their value with **`r`**
""" ->
function replace!(A,f,r)
    A[find(A.==f)]=r
end

export findone
@doc """
 Returns the indices of the first element in matrix **`A`** that has the value **`c`**
""" ->
function findone(A,c)
    A, B=findn(A.==c)
    A=A[1]; B=B[1]
    return A,B
end


# Basic graph routines

export neighboursize
@doc """
 Returns the number of neighbours in an graph

     nsize = neighboursize(A,<node>)

* `A`: adjacency matrix of the graph
* `node`: (_optional_) the node for which to find the number of neighbours

If **`node`** is missing, return the neighbour sizes (including self) of each node.
If **`A`** is directed, returns the number of parents of the specified node.
""" ->
function neighboursize(A,nodes=[])
    if isempty(nodes)
        nsize=sum(A,1);
    else
        nsize=sum(A[:,vec(nodes)],1);
    end
    return nsize
end

export istree
@doc """
 Checks if the input graph is singly-connected (a polytree)

    tree, elimseq, schedule = istree(A, <root>=[]; <ReturnElimSeq>=false)

##### Input :
* `A`: graph's adjacency matrix (zeros on diagonal)
* `root`: (_optional_) root node of the graph

##### Outputs:
* `tree`: _true_ if graph is singly connected, otherwise _false_
* `elimseq`: a variable elimination sequence in which simplical nodes of the tree are listed,
 as each simplical node is removed from the tree.
* `schedule`: the sequence of messages from node to node corresponding to elimseq

If **`A`** is a directed graph, the elimination schedule begins with the nodes with no children.
 If root is specified, the last node eliminated is root.

If the graph is connected and the number of edges is less than the number of nodes,
 it must be a tree. However, to deal with the general case in which it is unknown if the graph
 is connected w check using elimination.

A tree/singly-connected graph must admit a recursive simplical node elimination. That is at
 any stage in the elimination there must be a node with either 0 or 1 neighbours in the remaining graph.
""" ->
function istree(A,root=[];ReturnElimSeq=false)
    C = size(A,1); # number of nodes in the graph
    schedule=zeros(Int,C,2);
    tree=true; # assume A is singly connected
    AA=copy(A); # adjacency of the eliminated graph
    elimseq=[]; # set of variables eliminated (in sequence)

    for node=1:C
        # now find the number of neighbours:
        nn=(C+1)*ones(1,C);  # ensures that we don't pick eliminated nodes
        s=1:C; r=zeros(1,C);
        r[elimseq]=1; # need to check this
        s=s[find(r.==0)];
        nn[s]=neighboursize(AA',s)
        if !isempty(root)
            nn[root]=C+1 # ensures we don't pick root
        end

        val, elim=findmin(nn) # find node with least number of neighbours
        neigh = find(AA[:,vec(elim)]) # find the non zero elements

        if length(neigh)>1; # if least has more than 1 neighbour, cannot be a tree
            tree=false
            break;
        end

        AA[vec(elim),:]=0;  AA[:,vec(elim)]=0; # eliminate node from graph
        elimseq=[elimseq... elim]; # add eliminated node to elimination set

        if isempty(neigh);  schedule[node,:]=[elim elim];
        else
            schedule[node,:]=[elim neigh];
        end

    end
    if !tree;
        if ReturnElimSeq
            return false, [],[]
        else
            return false
        end
    end

    c=[]
    for i=1:size(schedule,1)
        if schedule[i,1]!=schedule[i,2] # remove self elimination
            c=[c... i]
        end
    end
     if ReturnElimSeq
         return tree, elimseq, schedule[vec(c),:]
     else
         return tree
     end
end

export findmax
@doc """
 Maximises a multi-dimensional array over a set of dimensions

    [maxval maxstate] = findmax(A, variables)

* `A`:         array to fill
* `variables`: <???>

Finds the values and states that maximize the multi-dimensional
 array **`A`** over the dimensions in <???>maxover
""" ->
function findmax(A,variables;Ind2Sub=false)

    maxval,maxind=findmax(A,variables)
    if !Ind2Sub
        return maxval, maxind
    end

    s=ind2sub(size(A),maxind[:]) # compatibilty with matlab BRML
    maxstate=zeros(Int64,length(s[1]),length(s))
    for i=1:length(s)
        maxstate[:,i]=s[i]
    end
    return maxval, maxstate

end

export randgen
@doc """
 Returns a random value from distribution **`p`**
""" ->
function randgen(p)
    p=p./sum(p)
    f=find(rand().<cumsum(vec(p)))
    return(Int(minimum(f)))
end

export myipermutedims
@doc """
 Wrapper for **`ipermutedims`** used for backward compatibility
 from porting the MATLAB version of BRML code
""" ->
function myipermutedims{T<:AbstractArray}(A::T,d)
    if length(d)==1 && d[1]==1
        return A
    else
        ipermutedims(A,d)
    end
end


export DictToArray
@doc """
 Copies the dictionary **D** values into a new vector
 with the size equal to the number of keys in the dictionary
""" ->
function DictToArray(D)
    if isa(D,Dict)
        L=length(collect(keys(D)))
        pot=Array(Any,L)
        ky=collect(keys(D))
        for k=1:length(keys(D))
            pot[k]=D[ky[k]]
        end
        return pot
    else
        return D
    end
end

#export iskey
#function iskey(k::Any,D::Dict)
#    allkeys=collect(keys(D))
#    return any(k.==allkeys)
#end

export condp
@doc """
 Creates a conditional distribution from an array

    pnew = condp(pin, varargin)

##### Input:
* `pin`:      a positive matrix
* `varargin`: optional input specifying which indices form the distribution variables

##### Output:
* `pnew`:    a new matrix with **`sum(pnew, 1) = ones(1, size(p, 2))`**

##### Example:
    r = rand(4, 2, 3);
    p = condp(r, DistributionIndices=[3, 1]);

**`p`** is now an array of the same size as **`r`**, but with **`sum(sum(p,3),1) = 1`** for each of the dimensions of the 2nd index.

*Note:*

**`p=condp(r,0)`** returns a normalised array **`p = r./sum(r(:))`**
""" ->
function condp(p; DistributionIndices::IntOrIntArray=[]) ## FIXME! This doesn't work when p is more than an 2D array
    p=p+realmin(); # in case all unnormalised probabilities are zero

    if isempty(DistributionIndices)
        p=p./repmat(sum(p,1),size(p,1),1)
        return p
    else
    if DistributionIndices==0
        p=p./sum(p[:])
        return p
    end
        allvars=1:length(size(p))
        sizevars=size(p)
        condvars=setdiff(allvars,DistributionIndices)
        newp=deepcopy(permutedims(p,vcat(DistributionIndices,condvars)))
        newp=reshape(newp,prod(sizevars[DistributionIndices]),prod(sizevars[condvars]))
        newp=newp./repmat(sum(newp,1),size(newp,1),1)
        pnew=reshape(newp,sizevars[vcat(DistributionIndices,condvars)])
        pnew=ipermutedims(pnew,vcat(DistributionIndices,condvars))
        return pnew
    end
end



#function condp(p, DistributionIndices=[]) ## FIXME! This doesn't work when p is more than an 2D array

#    if isempty(DistributionIndices)
#        p=p./repmat(sum(p,1),size(p,1),1)
#        return p
#    else
#    if DistributionIndices==0
#        p=p./sum(p[:])
#        return p
#    end
#        p=p+realmin(); # in case all unnormalised probabilities are zero
#        allvars=1:length(size(p))
#        sizevars=size(p)
#        condvars=setdiff(allvars,DistributionIndices)
#        newp=deepcopy(permutedims(p,vcat(DistributionIndices,condvars)))
#        newp=reshape(newp,prod(sizevars[DistributionIndices]),prod(sizevars[condvars]))
#        newp=newp./repmat(sum(newp,1),size(newp,1),1)
#        pnew=reshape(newp,sizevars[vcat(DistributionIndices,condvars)])
#        pnew=ipermutedims(pnew,vcat(DistributionIndices,condvars))
#        return pnew
#    end
#end



export condexp
@doc """
 Computes **`p`** proportional to **`exp(log p)`**
""" ->
function condexp(logp)
    pmax=maximum(logp,1)
    P =size(logp,1)
    return condp(exp(logp-repmat(pmax,P,1)))
end

export validgridposition
@doc """
 Returns `true` if point (x, y) is on a defined grid (1:Gx, 1:Gy)

    v = validgridposition(x, y, Gx, Gy)
""" ->
function validgridposition(x, y, Gx, Gy)
    if x > Gx || x < 1
        return false
    end
    if y > Gy || y < 1
        return false
    end
    return true
end

end #module
