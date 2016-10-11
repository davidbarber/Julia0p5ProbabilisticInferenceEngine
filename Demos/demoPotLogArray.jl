function demoPotLogArray()


    M1=rand(2,2)
    M2=rand(2,2)
    p1=PotArray([1 2],M1)
    p2=PotArray([2 3],M2)
    lp1=PotLogArray([1 2],log(M1))
    lp2=PotLogArray([2 3],log(M2))
    lA=FactorGraph([lp1 lp2])
    A=FactorGraph([p1 p2])

    marg,mess,normconst=sumprod([p1 p2],A)
    lmarg,lmess,lnormconst=sumprod([lp1 lp2],lA)

   println("Marginal table computed using Factor Graph running on standard PotArray, versus marginal table computed using Factor Graph running on LogPotArray:\n")

    println("log(PotArray) \t\t PotLogArray")
    for i=1:length(marg)
        println("\nvariable $i :")
        println("$([log(marg[i].content) lmarg[i].content])")
    end

end



