export condpot
function condpot{T<:Potential}(p::T,x::IntOrIntArray=[],y::IntOrIntArray=[])
    # compute p(x|y)=p(x,y)/p(y)
    if isempty(x) &&!isempty(y)
        error("first argument of condpot is empty and second argument is non-empty")
    end
    if isempty(x) && isempty(y)
        return p/sum(p)
    else
        if isempty(y)
            return(sum(p,x,SumOver=false)/sum(p))
        else
            pxy=sum(p,[x y],SumOver=false)
            py=sum(pxy,y,SumOver=false)
            return pxy/py
        end
    end
end


import Base.sum
function sum{T<:Potential,I<:Integer}(pots::Dict{I,T})
    # Sum potentials into a single potential
    return sum(convert(Array{T},pots))
end
export sum # is this needed?


import Base.prod
function prod{I<:Integer,P<:Potential}(D::Dict{I,P})
    p=convert(Array{Potential},D)
    return prod(p)
end

function prod(P::Potential)
    return P
end

# converters :
import Base.convert
function convert{T<:Potential,DT<:Potential,I<:Integer}(::Type{Array{T}}, D::Dict{I,DT})
    L=length(collect(keys(D)))
    pot=Array(Potential,L)
    ky=collect(keys(D))
    for k=1:length(keys(D))
        pot[k]=D[ky[k]]
    end
    return pot
end
export convert



export multpots
function multpots{P<:Potential}(pot::Array{P})
    if length(pot)==1
        return pot[1]
        else
            ind=[]
            for i=1:length(pot)
                if isdefined(pot,i) # remove #undef entries (missing)
                    ind=vcat(ind, i)
                end
            end
        if length(ind)==1
            return pot[ind]
        else
            return prod(pot[ind])
        end
    end
end

export standardisevariables
#function standardisevariables{DictOrArray{T<:Potential}}(inpot::T)
    #function standardisevariables{T<:Potential}(inpot::DictOrArray{T})
    # FIXME! NEED TO FIGURE OUT HOW TO DISPATCH ON ONLY DICTORARRY(subtype of Potential)
    function standardisevariables(inpot)
    # This just relabels the first from starting from 1
    pot=DictToArray(deepcopy(inpot))
    variables=potvariables(pot)
    for i=1:length(pot)
        pot[i].variables=memberinds(pot[i].variables,variables)
    end
    return pot, variables
end

export returnvariables
#function returnvariables{DictOrArray{T<:Potential}}(inpot::T,originalvariables)
#function returnvariables{T<:Potential}(inpot::DictOrArray{T},originalvariables)
function returnvariables(inpot,originalvariables)
    pot=DictToArray(deepcopy(inpot))
    variables=potvariables(pot)
    for i=1:length(pot)
        pot[i].variables=originalvariables[memberinds(pot[i].variables,variables)]
    end
    return pot
end

export potvariables
#function [variables nstates con convec]=potvariables(inpot)
function potvariables(inpot)
    # NEED TO EXTEND THIS TO RETURN ADDITIONAL INFO, LIKE THE MATLAB FUNCTION
    #POTVARIABLES Returns information about all variables in a set of potentials
    # [variables nstates con convec]=potvariables(pot)
    #
    # return the variables and their number of states
    # If there is a dimension mismatch in the tables then return con=0
    # convec(i)=0 reports that variable i has conflicting dimension

    pot=deepcopy(inpot) # don't want to change anything in caller
    pot=DictToArray(pot)

    if isempty(pot);return;end

    if !isa(pot,Array)
        tmp=deepcopy(pot)
        pot=Array(Potential,1)
        pot[1]=tmp
    end

    variables=[];
    for p=1:length(pot)
        variables=union(variables,pot[p].variables)
    end

    return variables

end

export dag
function dag(pot)
    #DAG Return the Dictionary list of edge for a Belief Network
    # Assumes that pot[i] contains the distribution p(i|pa(i))

    L=Dict{Integer,Array{Integer}}()
    vars=[];
    for p=1:length(pot)
        vars=vcat(vars, pot[p].variables)
    end
    N=maximum(vars)
    A=zeros(N,N);
    #for p=1:length(pot)
    #    L[p]=setdiff(pot[p].variables,p)
    #end
    for p=1:length(pot) ## might be better to insist that pot is itself a Dict
        pa=setdiff(pot[p].variables,p)
        for i=1:length(pa)
            if haskey(L,pa[i])
                L[pa[i]]=union(L[pa[i]],p)
            else
                L[pa[i]]=union([],p)
            end
        end
    end

    return L

end



export whichpot
function whichpot(pot,variables,n=1)
    #%WHICHPOT Returns potential that contain a set of variables
#% potnum = whichpot(pot,variables,<n>)
    #%
    #% Return potential numbers that contain all the specified variables
    #% The cliques are returned with those containing the smallest number of
    #% variables first.
    #% If optional n is used, returns at most n potential number
    potnum=[]; nvars=[];
    for p=1:length(pot)
        # find the potential that contains variables
        if prod(memberinds(variables,pot[p].variables))>0
            nvars=vcat(nvars,length(pot[p].variables));
            potnum=vcat(potnum,p);
    end
    end
    val=sort(nvars)
    ind=memberinds(val,nvars)
        potnum=potnum[ind[1:n]]
    if n==1
        potnum=potnum[1]
    end

    return potnum
end


export numvariables
function numvariables{T<:Potential}(A::T)
    length(A.variables)
end




