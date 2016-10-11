function HMMforward(v,phghm,ph1,pvgh;UseLogArray=true)
    #HMMFORWARD HMM Forward Pass
    # [alpha,loglik]=HMMforward(v,phghm,ph1,pvgh)
    #
    # Inputs:
    # v : visible (observation) sequence being a vector v=[2 1 3 3 1 ...]
    # phghm : homogeneous transition distribution phghm(i,j)=p(h(t)=i|h(t-1)=j)
    # ph1 : initial distribution
    # pvgh : homogeneous emission distribution pvgh(i,j)=p(v(t)=i|h(t)=j)
    #
    # Outputs:
    # alpha : p(h(t)|v(1:t))
    #           p(h(t)|v(1:t)) = p(v(t)|h(t)) * sum_{h(t-1)} {p(h(t)|h(t-1)) * p(h(t-1)|v(1:t-1))}
    #           alpha(t) = p(h(t)|v(1:t))
    #           alpha(t-1) = p(h(t-1)|v(1:t-1))
    # loglik : sequence log likelihood log p(v(1:T))

    T=length(v); H=length(ph1);

    pvghtrans=pvgh'
    z=zeros(1,T) # local normalisation factors
    alpha=zeros(H,T)
    alpha[:,1] = pvghtrans[:,v[1]].*ph1
    z[1]=sum(alpha[:,1])
    alpha[:,1]=alpha[:,1]./z[1]
    for t=2:T
        alpha[:,t]=pvghtrans[:,v[t]].*(phghm*alpha[:,t-1])
        z[t]=sum(alpha[:,t])
        alpha[:,t]=alpha[:,t]./z[t]
    end
    loglik = sum(log(z)) # log likelihood

    return alpha, loglik

end

