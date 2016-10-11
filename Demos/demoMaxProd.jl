function demoMaxProd()
    #DEMOMAXPROD Max-Product algorithm test :
    # Variable order is arbitary
    variables=1:5
    a, b, c, d, e=variables
    nstates=round(Int64,3*rand(1,5)+2) # random number of states for each variable

    pot=Array(PotArray,5)
    pot[1]=PotArray([a b],rand(nstates[[a b]]...));
    pot[2]=PotArray([b c d],rand(nstates[[b c d]]...));
    pot[3]=PotArray([c],rand(nstates[[c]]...));
    pot[4]=PotArray([e d],rand(nstates[[e d]]...));
    pot[5]=PotArray([d],rand(nstates[[d]]...));

    A = FactorGraph(pot)
    maxstate, maxval, mess=maxprod(pot,A)

    # check if this is correct by brute force max:
    jointpot =prod(pot); V=length(pot)
    maxval2,maxstate2=max(jointpot,variables,ReturnState=true,Ind2Sub=true)
    println("\t\t maxprod \t brute")
    for i=1:V
        println("Variable $i \t $(maxstate[i]...)\t\t $(maxstate2[i])")
    end





end
