function HMMviterbi(v,phghm,ph1,pvgh)
    #HMMVITERBI Viterbi most likely joint hidden state of a HMM
    # [maxstate logprob]=HMMviterbi(v,phghm,ph1,pvgh)
    #
    # Inputs:
    # v : visible (obervation) sequence being a vector v=[2 1 3 3 1 ...]
    # phghm : homogeneous transition distribution phghm(i,j)=p(h(t)=i|h(t-1)=j)
    # ph1 : initial distribution
    # pvgh : time-independent emission distribution pvgh(i,j)=p(v(t)=i|h(t)=j)
    #
    # Outputs:
    # maxstate : most likely joint hidden (latent) state sequence
    # logprob : associated log probability of the most likely hidden sequence

    T=length(v); H=size(phghm,1)
    mu=zeros(H,T)
    mu[:,T]=ones(H,1)
    hs=zeros(Int64,1,T)
    pvghtrans=pvgh'
    for t=T:-1:2
        tmp = repmat(pvghtrans[:,v[t]].*mu[:,t],1,H).*phghm
        tmp = maximum(tmp,1)'
        mu[:,t-1]= tmp./sum(tmp) # normalise to avoid underflow
    end

    # backtrack:
    val, hs[1]=findmax(ph1.*pvghtrans[:,v[1]].*mu[:,1])
    for t=2:T
        tmp = pvghtrans[:,v[t]].*phghm[:,hs[t-1]]
        val, hs[t]=findmax(tmp.*mu[:,t])
    end

    logprob=log(ph1[hs[1]])+log(pvgh[v[1],hs[1]])
    for t=2:T
        logprob=logprob+log(phghm[hs[t],hs[t-1]])+log(pvgh[v[t],hs[t]])
    end
    return hs, logprob
end
