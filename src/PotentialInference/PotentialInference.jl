module PotentialInference

importall BrmlFunctions

# Type definitions:

export Potential, DiscretePotential, ArrayPotential
abstract Potential
abstract DiscretePotential <: Potential
abstract ArrayPotential <: DiscretePotential


# Type Unions:
export DictOrArray
DictOrArray=Union{Dict,Array}


# Variable Types:
export Variable
abstract Variable

export DiscreteVariable
type DiscreteVariable <: Variable
    name
    state
    function DiscreteVariable(varname,varstates)
        new(varname,varstates)
    end
end


# Potential Types

export PotArray
type PotArray <: ArrayPotential
    variables
    content
    function PotArray(variables, content)
        content=standardise(content)
        if length(variables)!= length(mysize(content))
            error("number of variables does not match the size of the potential")
        end
        new(vec(variables),content)
    end
end

export Const
type Const <: Potential
    variables
    content
    function Const(content)
        if !isa(content,Number)
            error("Content must be a numerical scalar")
        end
        new([],content)
    end
end

export PotLogArray
type PotLogArray <: ArrayPotential
    variables
    content
    function PotLogArray(variables, content)
        content=standardise(content)
        if length(variables)!= length(mysize(content))
            error("number of variables does not match the size of the potential")
        end
        new(vec(variables),content)
    end
end

try
    current_path = joinpath((pwd()), "src", "PotentialInference")
    PotentialsPath = joinpath(current_path, "Potentials")
    AlgorithmsPath = joinpath(current_path, "Algorithms")
    include(joinpath(PotentialsPath, "ArrayPotential.jl"))
    include(joinpath(PotentialsPath, "Potential.jl"))
    include(joinpath(PotentialsPath, "PotArray.jl"))
    include(joinpath(PotentialsPath, "PotConst.jl"))
    include(joinpath(PotentialsPath, "PotLogArray.jl"))
    include(joinpath(AlgorithmsPath, "FactorGraph.jl"))
end

end # module
