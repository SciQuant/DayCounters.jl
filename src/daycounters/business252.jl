
struct Business252{T<:BusinessCalendar} <: DayCountConvention
  calendar::T
end
Business252(calendar = ArgentinaCalendar()) = Business252(calendar)

daysperyear(::Business252) = 252

# por ahora sin cache, el cache iria dentro de calendar? es mas, necesito cache?
daycount(dt1::Date, dt2::Date, c::Business252) = businessdaysbetween(dt1, dt2, c.calendar)

yearfraction(dt1::Date, dt2::Date, c::Business252) = daycount(dt1, dt2, c) / daysperyear(c)
