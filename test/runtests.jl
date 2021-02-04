using DayCounters
using Test

@testset "DayCounters.jl" begin
    @testset "ActualActual" begin include("actualactual.jl") end
    @testset "Business252" begin include("business252.jl") end
end
