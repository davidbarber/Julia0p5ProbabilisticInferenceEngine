function demoHMMinferenceFG()

    H = 6 # number of Hidden states
    V = 2 # number of Visible states
    T = 5 # length of the time-series
    # setup the HMM
    phghm = rand(H,H); phghm = phghm./repmat(sum(phghm,1),H,1);# transition distribution p(h(t)|h(t-1))
    pvgh = rand(V,H); pvgh = pvgh./repmat(sum(pvgh,1),V,1);# emission distribution p(v(t)|h(t))
    ph1 = rand(H,1); ph1=ph1./sum(ph1); # initial p(h)
    # generate some fake data
    h=Array(Int64,1,T)
    v=Array(Int64,1,T)
    h[1] = randgen(ph1); v[1]=randgen(pvgh[:,h[1]]);
    for t=2:T
        h[t]=randgen(phghm[:,h[t-1]]);	v[t]=randgen(pvgh[:,h[t]]);
    end
    # Perform Inference tasks:
    #[logalpha,loglik]=HMMforward(v,phghm,ph1,pvgh); % forward
    #logbeta=HMMbackward(v,phghm,pvgh); % backward
    #% smoothed posteriors:
    #[phtgV1T,phthtpgV1T]=HMMsmooth(logalpha,logbeta,pvgh,phghm,v);
    #gamma=HMMgamma(logalpha,phghm); % alternative alpha-gamma (RTS) method
    #[viterbimaxstate logprob]=HMMviterbi(v,phghm,ph1,pvgh); % most likely joint state

    # Factor graph approach:
    ht=1:T; vt=T+1:2*T; # assign numbers to variables
    pot=Array(PotArray,2*T)
    pot[ht[1]]=PotArray(ht[1],ph1);
    pot[vt[1]]=PotArray([vt[1] ht[1]], pvgh);
    for t=2:T
        pot[vt[t]]=PotArray([vt[t] ht[t]],pvgh);
        pot[ht[t]]=PotArray([ht[t] ht[t-1]],phghm);
    end

    newpot=Array(PotArray,T)
    for t=1:T; newpot[t]=multpots([setpot(pot[vt[t]],vt[t],v[t]) pot[ht[t]]]); end

    AFG = FactorGraph(newpot)
    marg, mess=sumprod(newpot,AFG)
    # likelihood
    dum1, fact2var, dum2=FactorConnectingVariable(ht[1],AFG); # can choose any of the variable nodes
    tmpmess = multpots(mess[fact2var])
    FGloglik = log(sum(tmpmess.content))

    # check:
    println("\nLog likelihood computed by SumProd Algorithm and Raw Summation:")
    println([FGloglik log((sum(prod(newpot))).content)])

    println("\nSmoothed Posterior marginal inference (smoothing) computed by SumProd verus Raw Summation:")

    for ht=1:T
        println("\nVariable $ht:")
        rawmarg=condpot(prod(newpot),ht)
        sumprodmarg=condpot(marg[ht],ht)
        println([sumprodmarg.content rawmarg.content])
    end

end
