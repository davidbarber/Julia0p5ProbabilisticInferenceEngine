function demoSumProd()
    #DEMOSUMPROD Sum-Product algorithm test :
    # Variable order is arbitrary
    variables=1:5
    a, b, c, d, e=variables
    nstates=round(Int64,3*rand(1,5)+2) # random number of states for each variable

    pot=Array(PotArray,5)
    pot[1]=PotArray([a b],rand(nstates[[a b]]...));
    pot[2]=PotArray([b c d],rand(nstates[[b c d]]...));
    pot[3]=PotArray([c],rand(nstates[[c]]...));
    pot[4]=PotArray([e d],rand(nstates[[e d]]...));
    pot[5]=PotArray([d],rand(nstates[[d]]...));

    A = FactorGraph(pot);
    marg, mess, normconst=sumprod(pot,A)

    # check if this is correct:
    jointpot =prod(pot); V=length(pot);
    for i=1:V
        mtable=[condpot(marg[i]).content condpot(jointpot,i).content]
        println("marginal of variable $i:\n Factor Graph\t\t Raw summation");
        println(mtable)
    end
    tmp=sum(prod(pot))
    println("Normalisation constant:\nFactorGraph\t=$(normconst.content)\nRaw summation\t=$(tmp.content)")

end
