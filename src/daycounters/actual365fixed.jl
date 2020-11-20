
@doc raw"""
    Actual365Fixed

Day count convention, also known as "Actual/365 (Fixed)", "Act/365 (Fixed)", or "A/365F".

!!! warning
    According to ISDA, "Actual/365" (without "Fixed") is an alias for "Actual/Actual (ISDA)"
    (see [`ActualActual`](@ref)). If Actual/365 is not explicitly specified as fixed in an
    instrument specification, you might want to double-check its meaning.
"""
struct Actual365Fixed <: DayCountConvention end

daysperyear(::Actual365Fixed) = 365

daycount(dt1::Date, dt2::Date, ::Actual365Fixed) = Dates.value(dt2 - dt1)

yearfraction(dt1::Date, dt2::Date, c::Actual365Fixed) = daycount(dt1, dt2, c) / daysperyear(c)

Base.show(io::IO, ::Actual365Fixed) = print(io, "Actual/365 (Fixed)")
