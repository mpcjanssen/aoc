using Base.Iterators
using BenchmarkTools
import IterTools.iterated

inputfile =  joinpath(@__DIR__,"../input/day02.txt")

program = parse.(Int, split(read(inputfile, String),","))
