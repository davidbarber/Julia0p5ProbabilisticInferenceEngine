function demoHMMinferenceSimple()

    V = 5  # number of visible states
    H = 10 # number of hidden states
    T = 20 # number of timesteps

    h = zeros(Integer,1,T) # holds the state value for the hidden variable at a specific timestep
    v = zeros(Integer,1,T) # holds the state value for the visible variable at a specific timestep

    ph1=condp(rand(H,1)) # probabilities for the states of the hidden variable at timestep 1

    phghm=condp(eye(H,H)) # transition matrix with sum(phghm, 1) = 1 with phghm[i, j] = p(hg=i | hm=j)

    # shuffle the column data in phghm while keeping sum(phghm, 1) = 1
    # below no 2 columns have value 1.0 on the same row
    phghmtmp=condp(eye(H,H))
    r=randperm(H)
    for i=1:H
        phghm[:,i]=phghmtmp[:,r[i]]
    end

    pvgh=condp((rand(V,H))) # emision matrix with sum(pvgh, 1) = 1 with pvgh[i, j] = p(vg = i | h = j)

    h[1]=randgen(ph1) # initialize the hidden variable h(t=1) with a random state based on ph1 distribution
    v[1]=randgen(pvgh[:,h[1]]) # initialize the visible variable v(t=1) with a random state based on pvgh(vg | h)

    for t=2:T
        h[t]=randgen(phghm[:,h[t-1]]) # set the hidden variable state h(t) based on h(t-1) using the transition matrix
        v[t]=randgen(pvgh[:,h[t]]) # set the visible variable state v(t) based on h(t) using the emission matrix
    end

    alpha,loglik=HMMforward(v,phghm,ph1,pvgh) # filtering

    gamma = HMMsmooth(v,phghm,ph1,pvgh,alpha) # smoothing

    maxstate,logprob = HMMviterbi(v,phghm,ph1,pvgh)

    println("Inference log likelihood = $loglik\n")
    println("most likely path (viterbi):\n")
    println(maxstate)
    println("original path (hidden states):")
    println(h)
    println("original path (visible states):")
    println(v)

    PyPlot.figure()
    ax = PyPlot.subplot(2, 1, 1)
    ax[:set_title]("filtering")
    PyPlot.pcolor(alpha)
    ax = PyPlot.subplot(2, 1, 2)
    ax[:set_title]("smoothing")
    PyPlot.pcolor(gamma)

end
