# @doc """
# EM algorithm for HMM
#     phghm, ph1, pvgh, loglikelihood = HMMem(v, H, V; MaxIterations=10, PlotProgress=false)
#
# ##### Inputs:
# * `v`: cell array containing sequences, so v{3}(5) is the 3rd sequence, 5th timestep
# * `H`: number of hidden states
# * `V`: number of visible (observation) states
#
# ##### Outputs:
# * `phghm`: learned transition p(h(t)|h(t-1))
# * `ph1`: learned initial distribution p(h(1))
# * `pvgh`: learned emission p(v|h)
# * `loglikelihood`: log likelihood of the sequences
# """ ->
function HMMem(v::Array{Any,1}, H, V; MaxIterations=10, PlotProgress=false)
    N = length(v) # number of sequences

    # random initialisation:
    phghm = condp(rand(H,H))    # transition distribution p(h(t)|h(t-1))
    pvgh = condp(rand(V,H))     # emission distribution p(v(t)|h(t))
    ph1 = condp(rand(H,1))      # initial p(h(1))
    llik = zeros(MaxIterations, N)
    loglik = zeros(N)

    if PlotProgress
        PyPlot.figure()
        ax=PyPlot.subplot(1,1,1)
    end

    for emloop = 1:MaxIterations
        A = zeros(H, H)
        a = zeros(H, 1)
        B = zeros(V, H)
        for n = 1:N

        # Perform Inference tasks (E step):
            alpha, loglik = HMMforward(v[n], phghm, ph1, pvgh)
            llik[emloop, :] = llik[emloop, :] + loglik
            beta = HMMbackward(v[n], phghm, pvgh)
            phtgV1T, phthtpgV1T = HMMsmooth(v[n], phghm, ph1, pvgh, alpha, beta, ReturnPairwiseMarginals=true)

        # Collect the statistics for the M-step:
            A = A + sum(phthtpgV1T, 3)[:, :, 1]
            a = a + phtgV1T[:, 1]
            for t = 1:length(v[n])
                i = v[n][t]
                #B[i, :] = B[i, :] + phtgV1T[:, t]'
                B[i, :] = B[i, :] + phtgV1T[:, t]
            end
        end
        # Perform M-step
        ph1 = condp(a)
        phghm = condp(A')
        pvgh = condp(B)
    end
    totalLogLik=sum(llik,2)
    if PlotProgress
        PyPlot.plot(totalLogLik); PyPlot.suptitle("log likelihood")
        println(minimum(totalLogLik))
        ax[:set_ylim](totalLogLik[2],totalLogLik[end])
    end
    loglikelihood = loglik[end]
    return phghm, ph1, pvgh, loglikelihood
end
