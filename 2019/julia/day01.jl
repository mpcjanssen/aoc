using Base.Iterators
using BenchmarkTools
import IterTools.iterated

function fuel(mass::Int64)
    mass ÷ 3 - 2
end

function day01()

    inputfile = joinpath(@__DIR__, "../input/day01.txt")
    input = open(inputfile) do fh
        parse.(Int64, readlines(fh))
    end

    fuels = fuel.(input)

    [
        fuels |> sum,
        collect.(takewhile.(>(0), iterated.(fuel, fuels))) .|> sum |> sum,
    ]
end

println(@time day01())
