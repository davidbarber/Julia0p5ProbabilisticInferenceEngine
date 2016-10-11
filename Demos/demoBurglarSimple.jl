function demoBurglarSimple()
    # This demo is the same as demoBurglar.jl, except that here we do not make use of the available potential indexing methods and also a potential dictionary (as in demoBurglarDictPot).

    burglar,earthquake,alarm,radio=1,2,3,4 # variables must start from 1 and be contiguous
    yes, no= 1,2 # define states, starting from 1. These do need to be contiguous, starting from 1, since currently the probability tables are defined by arrays of contiguous states.

    # This defines the meaning of the variables and their states.
    # It is not necessary for the computation, but is useful for
    # printing the results in a meaningful form:
    DictVariable=Dict{Integer,DiscreteVariable}()
    DictVariable[burglar]=DiscreteVariable("burglar",["yes","no"])
    DictVariable[earthquake]=DiscreteVariable("earthquake",["yes","no"])
    DictVariable[alarm]=DiscreteVariable("alarm",["yes","no"])
    DictVariable[radio]=DiscreteVariable("radio",["yes","no"])


    # Define the discrete probability tables:
    PotBurglar=PotArray(burglar,[0.01 0.99])
    PotEarthquake=PotArray(earthquake,[0.000001 1-0.000001])

    table=zeros(2,2)
    table[yes,yes]=1
    table[no,yes]=0
    table[yes,no]=0
    table[no,no]=1
    PotRadio=PotArray([radio earthquake],table)

    table=zeros(2,2,2)
    table[yes,yes,yes]=0.9999
    table[yes,yes,no]=0.99
    table[yes,no,yes]=0.99
    table[yes,no,no]=0.0001
    table[no,:,:]=1-table[yes,:,:]
    PotAlarm=PotArray([alarm burglar earthquake],table)

    jointpot=prod([PotBurglar PotRadio PotAlarm PotEarthquake])

    println("p(burglar|alarm=yes):")
    show(condpot(setpot(jointpot,alarm,yes),burglar),DictVariable)

    println("p(burglar|alarm=yes,radio=yes):")
    show(condpot(setpot(jointpot,[alarm radio],[yes yes]),burglar),DictVariable)

end
