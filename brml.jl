module brml

push!(LOAD_PATH, joinpath(pwd(), "src"))

# push all subdirectories from src
map(d -> push!(LOAD_PATH, joinpath(pwd(), "src", d)),
    filter(d -> isdir(joinpath("src", d)), readdir("src")))

push!(LOAD_PATH, joinpath(pwd(), "Demos"))

println("\nAvailable Demos:\n")
demos=readdir("Demos")
for i=1:length(demos)
    try
        if demos[i][1:4]=="demo" && demos[i][end-2:end]==".jl"
            println(demos[i])
            reload(demos[i])
        end
    end
end

using Reexport

@reexport using BrmlFunctions, HMM, PotentialInference, GraphPlot

end
