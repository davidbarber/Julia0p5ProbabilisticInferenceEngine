function demoHMMlearn()
    V = 2  # number of visible states
    H = 3 # number of hidden states
    N = 1000 # number of sequences to analyze

    ph1_true = condp(rand(H, 1)) # probabilities for the states of the hidden variable at timestep 1

    phghm_true = condp(rand(H, H)) # transition matrix with sum(phghm, 1) = 1 with phghm[i, j] = p(hg=i | hm=j), hg@t, hm@t-1
    pvgh_true = condp((rand(V, H))) # emision matrix with sum(pvgh, 1) = 1 with pvgh[i, j] = p(vg = i | h = j), vg@t h@t

    # generate training data
    #h = cell(N) # array with several hidden states sequences of various lengths
    #v = cell(N) # array with corresponding visible states sequences; type: Array{Any,1}
    h = Array{Any}(N) # array with several hidden states sequences of various lengths
    v = Array{Any}(N) # array with corresponding visible states sequences; type: Array{Any,1}
    T = zeros(Int, N) # vector with number of timesteps per sequence

    # generate N sequence pairs of hidden and visible states
    for n = 1:N
        T[n] = 20 + ceil(10 * rand()) # length in timesteps of the current sequence
        # initialize the current sequences
        h[n] = zeros(Int, T[n])  # type: Array{Int64,1}
        v[n] = zeros(Int, T[n])

        # populate the current sequences with random states based on transition and emission probabilities
        h[n][1] = randgen(ph1_true)
        v[n][1] = randgen(pvgh_true[:, h[n][1]])
        for t = 2:T[n]
            h[n][t] = randgen(phghm_true[:, h[n][t - 1]])
            v[n][t] = randgen(pvgh_true[:, h[n][t]])
        end
    end

    # EM algorithm (see if we can recover the true HMM parameters):
    phghm, ph1, pvgh, loglik = HMMem(v, H, V, MaxIterations=50, PlotProgress=true)
    println(loglik)

    # visualise the results
    # get sorting indices for initial probabilities
    hord_true = sortperm(ph1_true[:,1])
    hord = sortperm(ph1[:,1])

    PyPlot.figure()
    ax = PyPlot.subplot(1, 2, 1)
    ax[:set_title]("learned initial probabilities")
    PyPlot.bar([1,2,3], sort(ph1[hord]), color=[0,1,1])
    ax = PyPlot.subplot(1, 2, 2)
    ax[:set_title]("true initial probabilities")
    PyPlot.bar([1,2,3], sort(ph1_true[hord_true]), color=[0,1,0])

    PyPlot.figure()
    ax = PyPlot.subplot(1, 2, 1)
    ax[:set_title]("learned transition")
    #PyPlot.imshow(phghm[hord,hord])
    PyPlot.pcolor(phghm[hord,hord])
    ax = PyPlot.subplot(1, 2, 2)
    ax[:set_title]("true transition")
    #PyPlot.imshow(phghm_true[hord_true,hord_true])
    PyPlot.pcolor(phghm_true[hord_true,hord_true])

    PyPlot.figure()
    ax = PyPlot.subplot(1, 2, 1)
    ax[:set_title]("learned emission")
    #PyPlot.imshow(pvgh[:,hord])
    PyPlot.pcolor(pvgh[:,hord])
    ax = PyPlot.subplot(1, 2, 2)
    ax[:set_title]("true emission")
    #PyPlot.imshow(pvgh_true[:,hord_true])
    PyPlot.pcolor(pvgh_true[:,hord_true])
end
