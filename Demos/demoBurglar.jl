function demoBurglar()

    burglar,earthquake,alarm,radio=1,2,3,4 # Variable order is arbitary
    yes,no= 1,2 # define states, starting from 1

    # This defines the meaning of the variables and their states.
    # It is not necessary for the computation, but is useful for
    # printing the results in a meaningful form:
    DictVariable=Dict{Integer,DiscreteVariable}()
    DictVariable[burglar]=DiscreteVariable("burglar",["yes","no"])
    DictVariable[earthquake]=DiscreteVariable("earthquake",["yes","no"])
    DictVariable[alarm]=DiscreteVariable("alarm",["yes","no"])
    DictVariable[radio]=DiscreteVariable("radio",["yes","no"])

    # Define the discrete probability tables:
    pot=Array(PotArray,4) # there are 4 discrete potentials (arrays)
    pot[burglar]=PotArray(burglar,[0.01 0.99])
    pot[earthquake]=PotArray(earthquake,[0.000001 1-0.000001])

    table=zeros(2,2)
    table[yes,yes]=1
    table[no,yes]=0
    table[yes,no]=0
    table[no,no]=1
    pot[radio]=PotArray([radio earthquake],table)

    table=zeros(2,2,2)
    table[yes,yes,yes]=0.9999
    table[yes,yes,no]=0.99
    table[yes,no,yes]=0.99
    table[yes,no,no]=0.0001
    table[no,:,:]=1-table[yes,:,:]
    pot[alarm]=PotArray([alarm burglar earthquake],table)

    jointpot=prod(pot)

    println("p(burglar|alarm=yes):")
    show(condpot(setpot(jointpot,alarm,yes),burglar),DictVariable)

    println("p(burglar|alarm=yes,radio=yes):")
    show(condpot(setpot(jointpot,[alarm radio],[yes yes]),burglar),DictVariable)

    L=dag(pot)
    #try
        # This is just for plotting the DAG:
        DictPlot=Dict{Integer,VariablePlot}()
        DictPlot[burglar]=VariablePlot("Burglar",x=0,y=1,nodesize=0.3)
        DictPlot[earthquake]=VariablePlot("Earthquake",x=3,y=1,nodesize=0.35)
        DictPlot[alarm]=VariablePlot("Alarm",x=0,y=0,nodesize=0.2)
        DictPlot[radio]=VariablePlot("Radio",x=3,y=0,nodesize=0.2)

        PlotGraph(DictPlot,L)

        #PlotGraph(PlaceVertices(DictPlot,L,scale=5),L,arrowsize=0.2) # automatic node placement

    #end

end
