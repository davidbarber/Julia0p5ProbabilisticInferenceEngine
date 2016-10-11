import Base.*
function *(A::PotArray,B::PotArray)
    # multiply two PotArray potentials
    # eg  pot[1]*pot[2], or p*q

    A = standardise(A)
    B = standardise(B)

    allvars=sort(union(A.variables,B.variables))

    nvars=length(allvars)
    inds=ones(Int64,nvars,1)
    inds[1:nvars]=1:nvars

    ncvarsA=nvars-length(A.variables)

    if ncvarsA>0
        DsingularA=ones(Int64,1,nvars)
        DsingularA[ncvarsA+1:end]=[numstates(A.content)...]
        singularA=ones(typeof(A.content[1]),DsingularA...)
        singularA[1,:]=A.content
    else
        singularA=A.content
    end

    ncvarsB=nvars-length(B.variables)
    if ncvarsB>0
        DsingularB=ones(Int64,1,nvars);
        DsingularB[ncvarsB+1:end]=[numstates(B.content)...]
        singularB=ones(typeof(B.content[1]),DsingularB...)
        singularB[1,:]=B.content
    else
        singularB=B.content
    end


    tmpindA=memberinds(A.variables,allvars)
    singularAinds=myvcat(setdiff(inds,tmpindA),tmpindA)

    singularA=myipermutedims(singularA,singularAinds)

    tmpindB=memberinds(B.variables,allvars)
    singularBinds=myvcat(setdiff(inds,tmpindB),tmpindB)
    singularB=myipermutedims(singularB,singularBinds)


    return PotArray(allvars,broadcast(*,singularA,singularB))
end

import Base./
function /(A::PotArray,B::PotArray)
# divide two PotArray potentials

    # need to decide at some point whether to add epsilon to the denominator table

    A = standardise(A)
    B = standardise(B)

    allvars=sort(union(A.variables,B.variables))

    nvars=length(allvars)
    inds=ones(Int64,nvars,1)
    inds[1:nvars]=1:nvars

    ncvarsA=nvars-length(A.variables)


    if ncvarsA>0
        DsingularA=ones(Int64,1,nvars)
        DsingularA[ncvarsA+1:end]=[numstates(A.content)...]
        singularA=ones(typeof(A.content[1]),DsingularA...)
        singularA[1,:]=A.content
    else
        singularA=A.content
    end

    ncvarsB=nvars-length(B.variables)
    if ncvarsB>0
        DsingularB=ones(Int64,1,nvars);
        DsingularB[ncvarsB+1:end]=[numstates(B.content)...]
        singularB=ones(typeof(B.content[1]),DsingularB...)
        singularB[1,:]=B.content
    else
        singularB=B.content
    end

    tmpindA=memberinds(A.variables,allvars)
    singularAinds=myvcat(setdiff(inds,tmpindA),tmpindA)

    singularA=myipermutedims(singularA,singularAinds)

    tmpindB=memberinds(B.variables,allvars)
    singularBinds=myvcat(setdiff(inds,tmpindB),tmpindB)
    singularB=myipermutedims(singularB,singularBinds)

    return PotArray(allvars,broadcast(/,singularA,singularB))
end


import Base.+
function +(A::PotArray,B::PotArray)
    # Add two PotArray potentials

    A = standardise(A)
    B = standardise(B)

    allvars=sort(union(A.variables,B.variables))

    nvars=length(allvars)
    inds=ones(Int64,nvars,1)
    inds[1:nvars]=1:nvars

    ncvarsA=nvars-length(A.variables)

    if ncvarsA>0
        DsingularA=ones(Int64,1,nvars)
        DsingularA[ncvarsA+1:end]=[numstates(A.content)...]
        singularA=ones(typeof(A.content[1]),DsingularA...)
        singularA[1,:]=A.content
    else
        singularA=A.content
    end

    ncvarsB=nvars-length(B.variables)
    if ncvarsB>0
        DsingularB=ones(Int64,1,nvars);
        DsingularB[ncvarsB+1:end]=[numstates(B.content)...]
        singularB=ones(typeof(B.content[1]),DsingularB...)
        singularB[1,:]=B.content
    else
        singularB=B.content
    end
    tmpindA=memberinds(A.variables,allvars)

    singularAinds=myvcat(setdiff(inds,tmpindA),tmpindA)

    singularA=myipermutedims(singularA,singularAinds)

    tmpindB=memberinds(B.variables,allvars)
    singularBinds=myvcat(setdiff(inds,tmpindB),tmpindB)
    singularB=myipermutedims(singularB,singularBinds)

    return PotArray(allvars,broadcast(+,singularA,singularB))
end

import Base.-
function -(A::PotArray,B::PotArray)
    # subtract two PotArray potentials
    A = standardise(A)
    B = standardise(B)

    allvars=sort(union(A.variables,B.variables))

    nvars=length(allvars)
    inds=ones(Int64,nvars,1)
    inds[1:nvars]=1:nvars

    ncvarsA=nvars-length(A.variables)

    if ncvarsA>0
        DsingularA=ones(Int64,1,nvars)
        DsingularA[ncvarsA+1:end]=[numstates(A.content)...]
        singularA=ones(typeof(A.content[1]),DsingularA...)
        singularA[1,:]=A.content
    else
        singularA=A.content
    end

    ncvarsB=nvars-length(B.variables)
    if ncvarsB>0
        DsingularB=ones(Int64,1,nvars);
        DsingularB[ncvarsB+1:end]=[numstates(B.content)...]
        singularB=ones(typeof(B.content[1]),DsingularB...)
        singularB[1,:]=B.content
    else
        singularB=B.content
    end
    tmpindA=memberinds(A.variables,allvars)

    singularAinds=myvcat(setdiff(inds,tmpindA),tmpindA)

    singularA=myipermutedims(singularA,singularAinds)

    tmpindB=memberinds(B.variables,allvars)
    singularBinds=myvcat(setdiff(inds,tmpindB),tmpindB)
    singularB=myipermutedims(singularB,singularBinds)

    return PotArray(allvars,broadcast(-,singularA,singularB))
end



# this is automatically exported (not sure I understand why!)
import Base.sum # need this since sum is part of Base

function sum(A::PotArray,variables=A.variables;SumOver::Any=true)
    # Sum a PotArray over specified variables
    # eg sum(pot,[1 2])
    # sum(pot,[1 2],false) sums over all variables in pot except for [1 2]

    A=standardise(A) # makes A a vector potential if A is 1 D array

    if !SumOver
        variables = setdiff(A.variables,variables);
    end

    newvars=setdiff(A.variables,variables)
    table_variables=memberinds(variables,A.variables)
    tmp=sum(A.content,table_variables)
    #tmp=squeeze(tmp,find(memberinds(size(tmp),1)))
    tmp=squeeze(tmp,tuple(find(memberinds(size(tmp),1))...))
    return PotArray(newvars,tmp)
end


export setpot
function setpot(A::PotArray,variables,evidstates)
    # Set the value of a PotArray potential
    # eg setpot(pot,[1 2],[3 4]) sets variable 1 to state 3 and variable 2 to state 4
    ns=numstates(A)
    m=memberinds(variables,A.variables)
    for i=1:length(variables)
        tmp=zeros(1,ns[m[i]])
        tmp[evidstates[i]]=1
        q=PotArray(variables[i],tmp)
        A=A*q
    end
    A=sum(A,variables)
end



export setstate
function setstate(A::PotArray,variables,evidstates,val)
    # Set the value of a particular state in a potential
    # eg setstate(pot,[1 2],[3 4],0.5) sets all states of the potential that match variable 1 being in state 3 and variable 2 being in state 4 to the value 0.5

    # do this as ind(x==1)ind(y==1)*phi(1,1)+(1-ind(x==1)*ind(y==1))*phi(x,y)
    ns=numstates(A)
    m=memberinds(variables,A.variables)

    z=zeros(typeof(A.content[1]),1,ns[m[1]])
    z[evidstates[1]]=1
    d=PotArray(variables[1],z)
    for i=2:length(variables)
        z=zeros(typeof(A.content[1]),1,ns[m[i]])
        z[evidstates[i]]=1
        d=d*PotArray(variables[i],z)
    end
    dbar=PotArray(d.variables,ones(typeof(A.content[1]),numstates(d)))
    dbar=dbar-d
    d.content=d.content*val
    return d+A*dbar
end


export show
import Base.show
function show{I<:Integer}(p::PotArray,v::Dict{I,DiscreteVariable})
    # Display the values of a PotArray potential
    # eg show(pot,DictVariable) where DictVariable is Dictionary of variable information
    # see demoBurglar.jl
    #
    # disp() is equivalent to show()

    vars=p.variables
    ns=numstates(p)
    #st=states([ns...])
    if length(ns)>1
        st=states(collect(ns)')
    else
        st=1:ns
    end
    t=p.content
    for i=1:prod(ns)
        s=""
        for j=1:length(ns)
            s=s*"$(v[vars[j]].name)=$(v[vars[j]].state[st[i,j]])\t"
        end
        println(s*"$(t[i])")
    end
end

export disp
disp=show



import Base.findmax
function findmax(A::PotArray,variables;MaxOver=true,Ind2Sub=false)
    #MAX Maximise a multi-dimensional array over a set of dimenions
    # [maxval maxstate]=max(x,variables)
    # find the values and states that maximize the multidimensional array x
    # over the dimensions in maxover
    #

    maxval,maxind=findmax(A.content,variables)
    if !Ind2Sub
        return maxval, maxind
    end

    s=ind2sub(size(A),maxind[:]) # compatabilty with matlab BRML
    maxstate=zeros(Int64,length(s[1]),length(s))
    for i=1:size(A,2)
        maxstate[:,i]=s[i]
    end
    return PotArray(maxval, maxstate)

end





