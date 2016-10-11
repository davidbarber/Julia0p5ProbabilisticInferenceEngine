module LogArrayFunctions

export LogArray
type LogArray <: AbstractArray
    content
    function LogArray(content)
        new(content)
    end
end

import Base.display
function display(L::LogArray)
    return display(L.content)
end

import Base.size
function size(A::LogArray,I::Int64)
    return size(A.content,I)
end

function size(A::LogArray)
    return size(A.content)
end

import Base.permutedims
function permutedims(A::LogArray,I::Array{Int64,1})
    return permutedims(A.content,I)
end

function *(A::LogArray,B::LogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=exp(A.content-logprefactor)
    BB=exp(B.content-logprefactor)
    L=LogArray(1);
    L.content=2*logprefactor+log(AA*BB)
    return L
end

function +(A::LogArray,B::LogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=exp(A.content-logprefactor)
    BB=exp(B.content-logprefactor)
    L=LogArray(1);
    L.content=logprefactor+log(AA+BB)
    return L
end

import Base.sum
function sum(A::LogArray,I...)
    logprefactor=maximum(A.content[:])
    AA=exp(A.content-logprefactor)
    L=LogArray(1)
    L.content=logprefactor+log(sum(AA,I...))
    return L
end



import Base.ndims
function ndims(A::LogArray)
    return ndims(A.content)
end

import Base.getindex
function getindex(A::LogArray, I...)
    tmp=getindex(A.content,I...)
    return LogArray(tmp)
end


import Base.transpose
function transpose(A::LogArray)
    return LogArray((A.content)')
end

function .*(A::LogArray,B::LogArray)
    logprefactor=maximum([maximum(A.content[:]) maximum(B.content[:])]);
    AA=exp(A.content-logprefactor)
    BB=exp(B.content-logprefactor)
    L=LogArray(1);
    L.content=2*logprefactor+log(AA.*BB)
    return L
end

end #end module
