function HMMforward(v,phghm,ph1,pvgh;UseLogArray=true)
    #function [logalpha,loglik]=HMMforward(v,phghm,ph1,pvgh)
    #%HMMFORWARD HMM Forward Pass
    #% [alpha,loglik]=HMMforward(v,phghm,ph1,pvgh)
    #%
    #% Inputs:
    #% v : visible (observation) sequence being a vector v=[2 1 3 3 1 ...]
    #% phghm : homogeneous transition distribution phghm(i,j)=p(h(t)=i|h(t-1)=j)
    #% ph1 : initial distribution
    #% pvgh : homogeneous emission distribution pvgh(i,j)=p(v(t)=i|h(t)=j)
    #%
    #% Outputs:
    #% logalpha : log alpha messages: log p(h(t),v(1:t))
    #% loglik : sequence log likelihood log p(v(1:T))
    #% See also HMMbackward.m, HMMviterbi.m,  HMMsmooth.m, demoHMMinference.m

    T=length(v); H=length(ph1);

    if !UseLogArray # alpha recursion (not recommended due to numerical underflow)
        z=zeros(1,T)
        alpha=zeros(H,T)
        alpha[:,1] = pvgh[v[1],:]'.*ph1
        z[1]=sum(alpha[:,1])
        alpha[:,1]=condp(alpha[:,1])
        for t=2:T
            alpha[:,t]=pvgh[v[t],:]'.*(phghm*alpha[:,t-1])
            z[t]=sum(alpha[:,t])
            alpha[:,t]=condp(alpha[:,t])
        end
        loglik = sum(log(z)) # log likelihood
    end

    if UseLogArray
        logpvgh=LogArray(log(pvgh))
        logphghm=LogArray(log(phghm))
        logph1=LogArray(log(ph1))
        logalpha=Dict{Integer,LogArray}()
        logalphaoutput=zeros(H,T)
        logalpha[1] = logpvgh[v[1],:].'.*logph1
        logalphaoutput[:,1]=(logalpha[1]).content
        for t=2:T
            logalpha[t]=logpvgh[v[t],:].'.*(logphghm*logalpha[t-1])
            #if any(isnan(logalpha[t].content))
            #    return t,v,logpvgh,logphghm,logalpha
            #end
               
            logalphaoutput[:,t]=(logalpha[t]).content
        end
        loglik = (sum(logalpha[T])).content # log likelihood
    end

    return logalphaoutput, loglik

end

