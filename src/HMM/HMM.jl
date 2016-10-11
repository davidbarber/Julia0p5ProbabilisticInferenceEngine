module HMM
importall BrmlFunctions
#@reexport using BrmlFunctions, HMM, GraphPlot, Winston ## CHECK!!!

export HMMforward
include("HMMforward.jl")

export HMMbackward
include("HMMbackward.jl")

export HMMgamma
include("HMMgamma.jl")

export HMMsmooth
include("HMMsmooth.jl")

export HMMviterbi
include("HMMviterbi.jl")

export HMMem
include("HMMem.jl")

import PyPlot
export PyPlot

end
