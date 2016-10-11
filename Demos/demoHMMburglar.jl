function demoHMMburglar()

    # setup a grid representation of the rooom
    Gx = 5 # two dimensional grid size
    Gy = 5  
    H = Gx * Gy # number of states on grid

    # matrix representing the possible states of the system
    st = reshape(1:H, Gx, Gy) # assign each grid point a state

    # make a deterministic state transition matrix HxH on a 2D grid:
    phgh = zeros(H, H) # transition from state j to state i  
    for x = 1:Gx
        for y = 1:Gy
            # from the current state-cell (j coord in state transition matrix)
            # to next state-cell on (i coord in state transition matrix):
            #   the next row, same column
            if validgridposition(x + 1, y, Gx, Gy) # sample for x = 1, y = 2
                phgh[st[x + 1, y], st[x, y]] = 1 # 2,2=7  1,2=6
            end
            #   the previous row, same column
            if validgridposition(x - 1, y, Gx, Gy)
                phgh[st[x - 1, y], st[x, y]] = 1 # 0,2  1,2
            end
            #   the same row, next column
            if validgridposition(x, y + 1, Gx, Gy)
                phgh[st[x, y + 1], st[x, y]] = 1 # 1,3=11 1,2=6
            end
            #   the same row, previous column
            if validgridposition(x, y - 1, Gx, Gy)
                phgh[st[x, y - 1], st[x, y]] = 1 # 1,1=1 1,2=6
            end
        end
    end
    # conditional distribution from state transition matrix
    phghm = condp(phgh) # matrix with sum(phghm, 1) = 1 with phghm[i, j] = p(hg=i | hm=j)
    ph1=condp(ones(H,1)) # initialise probabilities for the states of the hidden variable at timestep 1
    pvgh=zeros(4,H) # initialise emision matrix

    pv1gh = 0.01 * ones(1,H); r = randperm(H); pv1gh[r[1:10]] = 0.9; # Creaks in 10 randomly chosen cells
    pv2gh = 0.01 * ones(1,H); r = randperm(H); pv2gh[r[1:10]] = 0.9; # Bumps in 10 randomly chosen cells

    PyPlot.figure()
    axc = PyPlot.subplot(2, 1, 1)
    axc[:set_title]("creaks layout")
    PyPlot.imshow(reshape(pv1gh, Gx, Gy), cmap="bone"); 
    axb = PyPlot.subplot(2, 1, 2)
    axb[:set_title]("bumps layout")
    PyPlot.imshow(reshape(pv2gh, Gx, Gy), cmap="bone");
    map([axb, axc]) do axesfig
        PyPlot.setp(axesfig[:get_xticklines](), visible=false)
        PyPlot.setp(axesfig[:get_xticklabels](), visible=false)
        PyPlot.setp(axesfig[:get_yticklines](), visible=false)
        PyPlot.setp(axesfig[:get_yticklabels](), visible=false) 
    end

    # Form the joint distribution p(v|h)=p(v1|h)p(v2|h) 
    # v = (v1, v2) and v1 and v2 are independent given h
    vv = zeros(4, 2)
    for i = 1:4
        pvgh[1, :] =  pv1gh .* pv2gh; vv[1, :] = [1 1]; # p(v1=1|h)*p(v2=1|h)
        pvgh[2, :] =  pv1gh.*(1-pv2gh); vv[2, :] = [1 2]; # p(v1=1|h)*p(v2=1|h)
        pvgh[3, :] =  (1-pv1gh).*pv2gh; vv[3, :] = [2 1]; # p(v1=1|h)*p(v2=1|h)
        pvgh[4, :] =  (1-pv1gh).*(1-pv2gh); vv[4, :] = [2 2]; # p(v1=1|h)*p(v2=1|h)
    end

    # draw some random samples:
    T=10 
    h = zeros(Integer, 1, T) # holds the state value for the hidden variable at a specific timestep
    v = zeros(Integer, 1, T) # holds the state value for the visible variable at a specific timestep

    h[1]=randgen(ph1) # initialize the hidden variable @t=1 with a random state based on ph1 distribution
    v[1]=randgen(pvgh[:, h[1]]) # initialize the visible variable @t=1 with a random state based on pvgh( vg | h@t=1)

    for t=2:T
        h[t]=randgen(phghm[:, h[t-1]]) # set the hidden variable state @t based on h@t-1 using the transition matrix
        v[t]=randgen(pvgh[:, h[t]]) # set the visible variable state @t based on h@t using the emission matrix
    end

    # Perform inference based on the observed v:
    (alpha, loglik) = HMMforward(v, phghm, ph1, pvgh) # filtering
    phtgV1t = alpha # filtered posterior - infer the current hidden state p(ht | v_1:t)

    phtgV1T = HMMgamma(alpha, phghm) # Smoothed Burglar distribution
    maxstate, logprob = HMMviterbi(v, phghm, ph1, pvgh) # Most likely Burglar path

    PyPlot.figure()
    for t = 1:T
        axg = PyPlot.subplot(5, T, t); PyPlot.imshow(repmat(vv[v[t], :], 2, 1), cmap="bone");
        if t == 2 # used t == 1 or t == 2 for title alignment only
            axg[:set_title]("Creaks and Bumps")
        end
        # add Filtering data row of T images from the previous row offset
        axf = PyPlot.subplot(5, T, T+t);  PyPlot.imshow(reshape(phtgV1t[:, t], Gx, Gy), cmap="bone");
        if t == 1 
            axf[:set_title]("Filtering")
        end
        # add Smoothing data row of T images from the previous row offset
        axs = PyPlot.subplot(5, T, 2*T+t);  PyPlot.imshow(reshape(phtgV1T[:, t], Gx, Gy), cmap="bone");
        if t == 1 
            axs[:set_title]("Smoothing")
        end
        z=zeros(H,1); z[maxstate[t]]=1;
        # add Viterbi data row of T images from the previous row offset
        axv = PyPlot.subplot(5,T,3*T+t); PyPlot.imshow(reshape(z,Gx,Gy), cmap="bone")
        if t == 1 
            axv[:set_title]("Viterbi")
        end
        z = zeros(H,1); z[h[t]] = 1;
        # add true data row of T images from the previous row offset
        axt = PyPlot.subplot(5,T,4*T+t); PyPlot.imshow(reshape(z,Gx,Gy), cmap="bone")
        if t == 2
            axt[:set_title]("True Burglar position")
        end
        map([axg, axf, axs, axv, axt]) do axesfig
            PyPlot.setp(axesfig[:get_xticklines](), visible=false)
            PyPlot.setp(axesfig[:get_xticklabels](), visible=false)
            PyPlot.setp(axesfig[:get_yticklines](), visible=false)
            PyPlot.setp(axesfig[:get_yticklabels](), visible=false) 
        end
    end

end
