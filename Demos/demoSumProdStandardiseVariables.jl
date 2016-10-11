function demoSumProdStandardiseVariables()
    #DEMOSUMPROD Sum-Product algorithm test :
    # Variable order is arbitary
    r=randperm(10)
    variables=r[1:5] # In this code, the variables do not need to be numbered 1:end
    a, b, c, d, e=variables
    nstates=round(Int64,3*rand(1,5)+2) # random number of states for each variable

    pot=Array(PotArray,5)
    pot[1]=PotArray([a b],rand(nstates[memberinds([a b],variables)]...))
    pot[2]=PotArray([b c d],rand(nstates[memberinds([b c d],variables)]...));
    pot[3]=PotArray([c],rand(nstates[memberinds([c],variables)]...));
    pot[4]=PotArray([e d],rand(nstates[memberinds([e d],variables)]...));
    pot[5]=PotArray([d],rand(nstates[memberinds([d],variables)]...));

    newpot,originalvariables=standardisevariables(pot) # translate the variables into 1:end form
    A = FactorGraph(newpot);
    newmarg, mess, normconst=sumprod(newpot,A)

    marg=returnvariables(newmarg,originalvariables) # translate back to orginal variables
    # check if this is correct:
    jointpot =prod(pot); V=length(pot);
    for i=variables
        mtable=[condpot(marg[whichpot(marg,i)]).content condpot(jointpot,i).content]
        println("marginal of variable $i:\n Factor Graph\t\t Raw summation");
        println(mtable)
    end
    tmp=sum(prod(pot))
    println("Normalisation constant:\nFactorGraph\t=$(normconst.content)\nRaw summation\t=$(tmp.content)")

end
