
"""
    DayCountConvention

Supertype for elements that provide methods for determining the length of a time period
according to given market convention, both as a number of days and as a year fraction.
"""
abstract type DayCountConvention end

# esta no se si exportarla y documentarla, podria aclarar que es una funcion auxiliar
# utilizada para el calculo de la year fraction
"""
    daysperyear(::DayCountConvention) -> Int64

Returns the number of days in a year considering the corresponding
[`DayCountConvention`](@ref).
"""
function daysperyear end

"""
    daycount(dt1::Date, dt2::Date, convention::DayCountConvention) -> Int64

Returns the number of days between two dates considering the corresponding
[`DayCountConvention`](@ref).
"""
function daycount end

"""
    yearfraction(dt1::Date, dt2::Date, convention::DayCountConvention) -> Real

Returns the period between two dates as a fraction of year considering the corresponding
[`DayCountConvention`](@ref).
"""
function yearfraction end

include("actual360.jl")
include("actual365fixed.jl")
include("actualactual.jl")
include("thirty360.jl")
include("business252.jl")
