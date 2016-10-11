
import Base.max
function max(pot::ArrayPotential,variables;MaxOver=true,ReturnState=false,Ind2Sub=false)
    #MAX Maximise a multi-dimensional array over a set of dimenions
    # maxval=max(x,variables)
    # find the values and states that maximize the multidimensional array x
    # over the dimensions in maxover
    #
    if !MaxOver
        variables = setdiff(pot.variables,variables)
    end

    newvars=setdiff(pot.variables,variables)
    max_variables=memberinds(variables,pot.variables)

    maxval,maxind=findmax(pot.content,max_variables) ## PROBABLY SHOULD CHANGE TO THE MAX FUNCTION -- NEED TO ENSURE THIS CAN WORK FOR ANY POTENTIAL

    #maxval=squeeze(maxval,find(memberinds(size(maxval),1)))
    maxval=squeeze(maxval,tuple(find(memberinds(size(maxval),1))...))

    outpot=deepcopy(pot)
    outpot.variables=newvars; outpot.content=maxval

    if !ReturnState
        return outpot
    end

    if !Ind2Sub
        return outpot, maxind
    end

    s=ind2sub(size(pot.content),maxind[:]) # return in more readable form
    maxstate=zeros(Int64,length(s[1]),length(s))
    for i=1:length(pot.variables)
        maxstate[:,i]=s[i]
    end

    return outpot, maxstate



end

##################################################################
# PotArray type functions:

export numstates
function numstates{T<:ArrayPotential}(A::T)

    if isavector(A.content)
        n=prod(size(A.content));
    else
        n=size(A.content);
    end
    return n
end



export standardise
function standardise{T<:ArrayPotential}(A::T)
    # If the ArrayPotential is a vector, make this a column vector, otherwise leave unchanged
    if isavector(A.content)
        A.content=vec(A.content)
        end
    return A
end

