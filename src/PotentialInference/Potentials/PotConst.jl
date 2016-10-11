function *(A::Const,B::PotLogArray)
    L=PotLogArray(B.variables,log(A.content)+B.content)
    return L
end

# Not sure I understand this but Julia automatically exports *,+,-,/
#function *(A::Const,B::Const)
#    C=Const(A.content*B.content)
#end
# must be a smarter way to do the following using macros:!
function *(A::Const,B::Const)
    return Const(A.content*B.content)
end
function /(A::Const,B::Const)
    return Const(A.content/B.content)
end
function +(A::Const,B::Const)
    return Const(A.content+B.content)
end
function -(A::Const,B::Const)
    return Const(A.content-B.content)
end
function *(P::PotArray,C::Const)
    p = deepcopy(P); p.content=C.content*p.content
    return p
end



function *(C::Const,P::PotArray)
    p = deepcopy(P); p.content=C.content*p.content
    return p
end
function /(P::PotArray,C::Const)
    p = deepcopy(P); p.content=p.content/C.content
    return p
end
function +(P::PotArray,C::Const)
    p = deepcopy(P); p.content=C.content+p.content
    return p
end
function +(C::Const,P::PotArray)
    p = deepcopy(P); p.content=C.content+p.content
    return p
end
function -(P::PotArray,C::Const)
    p = deepcopy(P); p.content=C.content-p.content
    return p
end
function -(C::Const,P::PotArray)
    p = deepcopy(P); p.content=C.content-p.content
    return p
end


function convert(::Type{PotArray},c::Const)
    return PotArray([],c.content)
end

