
@doc raw"""
    Actual360([lastday = false])

Day count convention, also known as "Actual/360", "Act/360", or "A/360". Can include the
last day in computations depending on the `lastday` value.
"""
struct Actual360 <: DayCountConvention
  lastday::Bool
  Actual360(lastday = false) = new(lastday)
end

daysperyear(::Actual360) = 360

daycount(dt1::Date, dt2::Date, c::Actual360) = Dates.value(dt2 - dt1) + c.lastday

yearfraction(dt1::Date, dt2::Date, c::Actual360) = daycount(dt1, dt2, c) / daysperyear(c)

Base.show(io::IO, c::Actual360) = c.lastday ? print(io, "Actual/360 (inc)") : print(io, "Actual/360")
