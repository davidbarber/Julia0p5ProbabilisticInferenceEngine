function demoPlotDAG()
#    try
        # variables:
        D=Dict{Integer,VariablePlot}()
        D[1]=VariablePlot("1")
        D[2]=VariablePlot("2")
        D[3]=VariablePlot("3")
        D[4]=VariablePlot("4")
#        D[5]=VariablePlot("5")
#        D[6]=VariablePlot("6")

        # connections:
        L=Dict{Integer,Array{Integer}}()

        if false
        L[1]=[2,4]
        L[2]=[3,5]
        L[3]=[6]
            end

        L[1]=[2,3]
        L[4]=[3]
        L[3]=[4]


        if false
        L[1]=[2,5,4] # connection from variable 1 to 2
        L[2]=[1,5,3]
        L[3]=[2,5,4]
        L[4]=[3,5,1]
        L[5]=[1,2,3,4]
        end



        if false
        L[1]=[2,3,4] # connection from variable 1 to 2
        L[2]=[4]
        L[3]=[4]
        L[4]=[5]
        L[5]=[2,1]
            end

        PlotGraph(PlaceVertices(D,L,scale=2),L)
        #PlotGraph(PlaceVertices(D,L,scale=2,UseEnergyApproach=true),L,arrowsize=0.02) # rerun this if the vertex placement is not good
#    end
end
