function HMMsmooth(v,phghm,ph1,pvgh,alpha=[],beta=[];ReturnPairwiseMarginals=false,ReturnLogLikelihood=false)
    #HMMSMOOTH Smoothing for a Hidden Markov Model (HMM)
    # [phtgV1T,phthtpgV1T]=HMMsmooth(v,phghm,ph1,pvgh)
    # Return the HMM pointwise p(h(t)|v(1:T)) and pairwise posterior p(h(t),h(t+1)|#v(1:T)).
    #
    # Inputs:
    # v : visible (observation) sequence
    # phghm : transition distribution
    # ph1 : initial distribution
    # pvgh : emission distribution p(v|h)
    #
    # Outputs:
    # phtgV1T : smoothed posterior p(h(t)|v(1:T))
    # phthtpgV1T : smoothed pair p(h(t),h(t+1)|v(1:T))
    T=length(v); H=size(phghm,1);

    if isempty(alpha)
        alpha,loglik=HMMforward(v,phghm,ph1,pvgh)
    end
    if isempty(beta)
        beta=HMMbackward(v,phghm,pvgh)
    end

    # smoothed posteriors: pointwise marginals:
    phtgV1T=zeros(H,T)
    for t=1:T
        tmp=alpha[:,t].*beta[:,t]
	phtgV1T[:,t]=tmp./sum(tmp)
    end

    if ReturnPairwiseMarginals
        # smoothed posteriors: pairwise marginals p(h(t),h(t+1)|v(1:T)):
        phthtpgV1T=zeros(H,H,T-1)
        for t=1:T-1
	    atmp=alpha[:,t]
	    btmp=beta[:,t+1]
	    #ctmp = repmat(atmp,1,H).*phghm'.*repmat(pvgh[v[t+1],:].*btmp',H,1)
            ctmp = repmat(atmp,1,H).*phghm'.*repmat(pvgh[v[t+1],:]'.*btmp',H,1)
	    phthtpgV1T[:,:,t]=ctmp./sum(ctmp)
        end
        if ReturnLogLikelihood
            return phtgV1T, phthtpgV1T, loglik
        end
        return phtgV1T, phthtpgV1T
    end

    if ReturnLogLikelihood
        return phtgV1T,loglik
    end
    return phtgV1T
end
