function *(A::PotLogArray,B::PotLogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=PotArray(A.variables,exp(A.content-logprefactor))
    BB=PotArray(B.variables,exp(B.content-logprefactor))
    AB=AA*BB
    L=PotLogArray(AB.variables,2*logprefactor+log(AB.content))
    return L
end

function /(A::PotLogArray,B::PotLogArray)
    BB=deepcopy(B)
    BB.content=-BB.content
    return A*BB
end



function +(A::PotLogArray,B::PotLogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=PotArray(A.variables,exp(A.content-logprefactor))
    BB=PotArray(B.variables,exp(B.content-logprefactor))
    AB=AA+BB
    L=PotLogArray(AB.variables,logprefactor+log(AB.content))
    return L
end

function -(A::PotLogArray,B::PotLogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=PotArray(A.variables,exp(A.content-logprefactor))
    BB=PotArray(B.variables,exp(B.content-logprefactor))
    AB=AA-BB
    L=PotLogArray(AB.variables,logprefactor+log(AB.content))
    return L
end


function *(A::PotArray,B::PotLogArray)
    logprefactor=maximum([maximum(log(A.content[:])) maximum(B.content[:])]);
    AA=PotArray(A.variables,exp(log(A.content)-logprefactor))
    BB=PotArray(B.variables,exp(B.content-logprefactor))
    AB=AA*BB
    L=PotLogArray(AB.variables,2*logprefactor+log(AB.content))
    return L
end


function *(A::PotLogArray,B::Const)
    return B*A
end

function *(A::PotLogArray,B::PotArray)
    return B*A
end



function sum(A::PotLogArray,variables=A.variables;SumOver::Any=true)
    # Sum a PotLogArray over specified variables
    # eg sum(pot,[1 2])
    # sum(pot,[1 2],false) sums over all variables in pot except for [1 2]

    A=standardise(A) # makes A a vector potential if A is 1 D array

    logprefactor=maximum(A.content[:]);
    pA=PotArray(A.variables,exp(A.content-logprefactor))

    if !SumOver
        variables = setdiff(A.variables,variables);
    end

    newvars=setdiff(A.variables,variables)
    table_variables=memberinds(variables,A.variables)
    tmp=sum(pA.content,table_variables)
    #tmp=squeeze(tmp,find(memberinds(size(tmp),1)))
    tmp=squeeze(tmp,tuple(find(memberinds(size(tmp),1))...))

    return PotLogArray(newvars,log(tmp)+logprefactor)
end


