function HMMgamma(alpha,phghm)
    #HMMGAMMA HMM Posterior smoothing using the Rauch-Tung-Striebel correction method
    # gamma=HMMbackward(alpha,phghm)
    #
    # Inputs:
    # alpha : alpha forward messages (see HMMforward.m)
    # phghm : transition distribution in a matrix
    #
    # Outputs: gamma(i,t) is p(h(t)=i|v(1:T))
    # See also HMMbackward.m, HMMviterbi.m, demoHMMinference.m

    T=size(alpha,2); H=size(phghm, 1);
    # gamma recursion
    gamma=zeros(size(alpha))
    gamma[:,T]=alpha[:,T];
    for t=T-1:-1:1
        phghp=condp(phghm'.*repmat(alpha[:,t],1,H));
        gamma[:,t]=condp(phghp*gamma[:,t+1]);
    end

    if 1==0 # gamma recursion: More human readable
        gamma[:, T]=alpha[:, T]./sum(alpha[:, T])
        for t = T-1:-1:1
            phghp=phghm'.*repmat(alpha[:,t],1,H)
            phghp=phghp./repmat(sum(phghp, 1),H,1)
            gamma[:,t]=phghp*gamma[:,t+1]
        end
    end
    return gamma
end
