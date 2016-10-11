
export mess2var
function mess2var(vars,FG;ShowFactors=false)
    #MESS2VAR Returns the message numbers that connect into variables v
    # [messnum fact]=mess2var(vars,FG)
    # vars is a vector of variables
    #
    # messnum(i) is the message number from factor fact(i) to vars(i)
    # FG is a Factor Graph
    # see also mess2fact.m, FactorConnectingVariable.m, FactorGraph.m

    V=minimum(find(FG[1,:]))-1; # variables are first in the order
    messnum=[]; fact=[];
    for v=vars
        tmp=vec(full(FG[:,v]));
        tmp2=tmp.>0;
        messnum = vcat(messnum,tmp[tmp2]);
        fact=vcat(fact, find(tmp2)-V);
    end
    if ShowFactors
        return messnum, fact
    else
        return messnum
    end
end


export sumprod
function sumprod(pot,A;InitialMessages=[])

    variables=potvariables(pot)
    V=length(variables); N=size(A,1)
    fnodes=zeros(Int64,1,N); fnodes[V+1:end]=1:N-V; # factor nodes
    vnodes=zeros(Int64,1,N); vnodes[1:V]=1:V; # variable nodes
    nmess=maxarray(A);
    mess=Array(Potential,nmess)
    InitialMessages=[]
    if !isempty(InitialMessages); mess=InitialMessages; end
    if isempty(InitialMessages) # message initialisation
        for mcount=1:nmess
            mess[mcount]=Const(1)
            FGnodeA, FGnodeB=findone(A,mcount);
            if fnodes[FGnodeA].>0 # factor to variable message:
                # if the factor is at the edge (simplical), need to set message to the factor potentials
                if length(find(A[FGnodeA,:]))==1
                    mess[mcount]=pot[fnodes[FGnodeA]];
                end
            end
        end
    end

 # Do the message passing:
    for mcount=1:length(mess)
        FGnodeA, FGnodeB=findone(A,mcount);
        FGparents=setdiff(find(A[FGnodeA,:]),FGnodeB) # FG parent nodes of FGnodeA
        if !isempty(FGparents)
#            tmpmess = prod(mess[A[FGparents,FGnodeA]]) # product of incoming messages
            # At the moment (0.3.0 rc2) Julia assumes prod(single element) is an error. I don't know how to dispatch on the size of an input, so unfortunately need to define my own prod function:
            tmpmess = multpots(mess[A[FGparents,FGnodeA]]) # product of incoming messages
            mfactor=fnodes[FGnodeA]
            if mfactor==0 # variable to factor message:
                mess[mcount]=tmpmess
            else # factor to variable message:
                tmpmess = multpots([tmpmess pot[mfactor]])
                mess[mcount] = sum(tmpmess,FGnodeB,SumOver=false)
            end
        end
    end
    # Get all the marginals: variable nodes are first in the ordering, so
    marg=Array(Potential,V)
    for i=1:V
        dum1, dum2, incoming=findnz(A[:,i]');
        tmpmess = multpots(mess[incoming]);
        marg[i]=tmpmess;
    end
    normconstpot=sum(multpots(mess[mess2var(1,A)]));
    return marg, mess, normconstpot
end



export maxprod
function maxprod(pot,A;InitialMessages=[])

    variables=potvariables(pot)
    V=length(variables); N=size(A,1)
    fnodes=zeros(Int64,1,N); fnodes[V+1:end]=1:N-V; # factor nodes
    vnodes=zeros(Int64,1,N); vnodes[1:V]=1:V; # variable nodes
    nmess=maxarray(A);
    mess=Array(Potential,nmess)
    InitialMessages=[]
    if !isempty(InitialMessages); mess=InitialMessages; end
    if isempty(InitialMessages) # message initialisation
        for mcount=1:nmess
            mess[mcount]=Const(1)
            FGnodeA, FGnodeB=findone(A,mcount);
            if fnodes[FGnodeA].>0 # factor to variable message:
                # if the factor is at the edge (simplical), need to set message to the factor potentials
                if length(find(A[FGnodeA,:]))==1
                    mess[mcount]=pot[fnodes[FGnodeA]];
                end
            end
        end
    end

 # Do the message passing:
    for mcount=1:length(mess)
        FGnodeA, FGnodeB=findone(A,mcount);
        FGparents=setdiff(find(A[FGnodeA,:]),FGnodeB) # FG parent nodes of FGnodeA
        if !isempty(FGparents)
            tmpmess = multpots(mess[A[FGparents,FGnodeA]]) # product of incoming messages
            mfactor=fnodes[FGnodeA]
            if mfactor==0 # variable to factor message:
                mess[mcount]=tmpmess
            else # factor to variable message:
                tmpmess = multpots([tmpmess pot[mfactor]])
                mess[mcount] = max(tmpmess,FGnodeB,MaxOver=false)
            end
        end
    end

    # now find the maximum states: variable nodes are first in the ordering:
    maxstate=Dict{Integer,Any}()
    maxval=[] # ensure that is in scope
    for i=1:V
        #dum1, dum2, incoming=findnz(A[:,i])
        dum1, incoming=findnz(A[:,i])
        tmpmess = multpots(mess[incoming])
        tmpmess,maxstate[i]=max(tmpmess,i,ReturnState=true)
        maxval=tmpmess.content
    end

    return maxstate, maxval, mess
end


#function [f fact2varmess var2factmess] = FactorConnectingVariable(vars,A)
export FactorConnectingVariable
function FactorConnectingVariable(vars,A)
    #%FACTORCONNECTINGVARIABLE Factor nodes connecting to a set of variables
    #% [f fact2varmess var2factmess] = FactorConnectingVariable(vars,A)
    #% find the intersection of factor indices that connect to variables vars.
    #% fact2varmess are the message indices connecting the factors f to the variable
    #% var2factmess are the message indices from the variables to the factors f
    #% A is a Factor Graph
    #% vars are the variables
    #% see also FactorGraph.m, demoSumProd.m, mess2fact.m, fact2mess.m
    c=1
    for v=vars
        if c==1
            f = find(A[v,:]);
        else
            f = intersect(f,find(A[v,:]));
        end
        c=c+1
    end
    fact2varmess=[];var2factmess=[];
    for fn=f
        fact2varmess=full(union(fact2varmess,A[fn,vars]));
        var2factmess=full(union(var2factmess,A[vars,fn]));
    end
    V=minimum(find(A[1,:]))-1; # variables are first in the order
    f=full(f-V)
    return f, fact2varmess, var2factmess
end

export FactorGraph
function FactorGraph(pot::DictOrArray)
    #FACTORGRAPH Returns a Factor Graph adjacency matrix based on a cell of potentials.
    # A = FactorGraph(pot)
    #
    # pot is a set of potentials and the routine returns the Factor Graph
    # (sparse) adjacency matrix A. The size of A is equal to
    # (V+F)*(V+F) where V are the total number of variables and F the total
    # number of factors. A(1:V,1:V) and A(V+1:end,V+1:end) are empty;
    # A(1:V,V+1:end) contains the variable to factor message indices and
    # A(V+1:end,1:V) contains the factor to variable message indices
    # If the set of potentials is not singly-connected, all message indices are -1
    #
    #
    # A(i,j)=k means that message number k is from FGnodei -> FGnodej
    # Going through the messages in sequence corresponds to a valid
    # forward-backward procedure over all variable nodes in the Factor Graph.
    # See also FactorConnectingVariable.m, VariableConnectingFactor.m
    # Note that the variables in pot must be numbered 1,2,3,...
    #
    # See also demoSumProd.jl

    F=length(pot) # number of factors (potentials in distribution)
    variables=potvariables(pot)
    if variables[end]!=length(variables);
        error("potential variables used are not numbered 1:end. Use standarisevariables.jl. See demoSumProdStandariseVariables"); end

    V=length(variables)
    N=V+F # all nodes in factor graph

    vnodes=zeros(Int64,1,N); vnodes[1:V]=1:V # variable nodes
    fnodes=zeros(Int64,1,N); fnodes[V+1:end]=1:F # factor nodes
    A = SparseIntMatrix(N,N)
    for f=1:length(pot)
        FGnodeA=find(fnodes.==f)
        FGnodeB=vec(memberinds(pot[f].variables,variables))
        fillmatrix!(A,FGnodeA,FGnodeB[:],1)
        fillmatrix!(A,FGnodeB[:],FGnodeA,1)
    end
    # get a message passing sequence and initialise the messages
    #tree, elimseq, forwardschedule=istree(full(A),ReturnElimSeq=true); ## change to sparse
    tree, elimseq, forwardschedule=istree(A,ReturnElimSeq=true); ## change to sparse
    #reverseschedule=flipud(fliplr(forwardschedule));
    reverseschedule=flipdim(flipdim(forwardschedule,2),1);
    schedule=vcat(forwardschedule,reverseschedule);

    if tree
        for count=1:size(schedule,1)
            # setup the structure for a message from FGnodeA -> FGnodeB
            FGnodeA, FGnodeB = schedule[count,:]
            A[FGnodeA,FGnodeB]=count; # store the FG adjacency matrix with mess number on edge
        end
    else
        A = replace(A,1,-1);
    end


    return A

end



