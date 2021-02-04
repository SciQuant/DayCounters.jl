
abstract type BusinessCalendar end

abstract type WesternCalendar <: BusinessCalendar end
# const GregorianCalendar = WesternCalendar

abstract type OrthodoxCalendar <: BusinessCalendar end
# const EasternCalendar = OrthodoxCalendar

abstract type MarketCalendar end

include("utils.jl")
include("argentina.jl")
include("brazil.jl")
include("unitedstates.jl")
include("target.jl")

"""
    isbusinessday(dt::Date, calendar::BusinessCalendar) -> Bool

Provides methods for determining whether a date `dt` is or not a business day. A `calendar`,
defined for specific exchange holiday schedule or for general country holiday schedule, must
be provided.
"""
function isbusinessday end

"""
    isholiday(dt::Date, calendar::BusinessCalendar) -> Bool

Provides methods for determining whether a date `dt` is or not a holiday. A `calendar`,
defined for specific exchange holiday schedule or for general country holiday schedule, must
be provided.
"""
isholiday(dt::Date, calendar::BusinessCalendar) = !isbusinessday(dt, calendar)

"""
    BusinessDayConvention

Supertype for elements that provide algorithms used to adjust a date in case it is not a
valid business day.
"""
abstract type BusinessDayConvention end

"""
    Unadjusted

A [`BusinessDayConvention`](@ref) subtype that provides no date adjustment.
"""
struct Unadjusted <: BusinessDayConvention end

"""
    Following

A [`BusinessDayConvention`](@ref) subtype that chooses the first business day after the
given holiday.
"""
struct Following <: BusinessDayConvention end

"""
    ModifiedFollowing

A [`BusinessDayConvention`](@ref) subtype that chooses the first business day after the
given holiday unless it belongs to a different month, in which case choose the first
business day before the holiday.
"""
struct ModifiedFollowing <: BusinessDayConvention end

"""
    Preceding

A [`BusinessDayConvention`](@ref) subtype that chooses the first business day before the
given holiday.
"""
struct Preceding <: BusinessDayConvention end

"""
    ModifiedPreceding

A [`BusinessDayConvention`](@ref) subtype that chooses the first business day before the
given holiday unless it belongs to a different month, in which case choose the first
business day after the holiday.
"""
struct ModifiedPreceding <: BusinessDayConvention end

"""
    HalfMonthModifiedFollowing

A [`BusinessDayConvention`](@ref) subtype that chooses the first business day after the
given holiday unless that day crosses the mid-month (15th) or the end of month, in which
case choose the first business day before the holiday.
"""
struct HalfMonthModifiedFollowing <: BusinessDayConvention end

"""
    Nearest

A [`BusinessDayConvention`](@ref) subtype that chooses the nearest business day to the given
holiday. If both the preceding and following business days are equally far away, default to
following business day.
"""
struct Nearest <: BusinessDayConvention end

"""
    adjustdate(dt::Date, calendar::BusinessCalendar, [convention::BusinessDayConvention = Following()]) -> Date

Adjusts a non-business day to the appropriate near business day with respect to the given
convention. The convention defaults to [`Following`](@ref) if not provided.
"""
function adjustdate end

# default
adjustdate(dt::Date, calendar::BusinessCalendar, ::BusinessDayConvention) =
    adjustdate(dt, calendar, Following())

adjustdate(dt::Date, ::BusinessCalendar, ::Unadjusted) = dt

function adjustdate(dt::Date, calendar::BusinessCalendar, ::Following)

    # loop until a "following" business day is reached
    while isholiday(dt, calendar)
        dt += Day(1)
    end

    return dt
end

function adjustdate(dt::Date, calendar::BusinessCalendar, ::Preceding)

    # loop until a "preceding" business day is reached
    while isholiday(dt, calendar)
        dt -= Day(1)
    end

    return dt
end

function adjustdate(dt::Date, calendar::BusinessCalendar, ::ModifiedFollowing)

    # get the following business day
    dt′ = adjustdate(dt, calendar, Following())

    # si cambia el mes, buscamos para atras
    if month(dt′) != month(dt)
        return adjustdate(dt, calendar, Preceding())
    else
        return dt′
    end
end

function adjustdate(dt::Date, calendar::BusinessCalendar, ::ModifiedPreceding)

    # get the following business day
    dt′ = adjustdate(dt, calendar, Preceding())

    # si cambia el mes, buscamos para adelante
    if month(dt′) != month(dt)
        return adjustdate(dt, calendar, Following())
    else
        return dt′
    end
end

function adjustdate(dt::Date, calendar::BusinessCalendar, ::HalfMonthModifiedFollowing)

    # get the following business day
    dt′ = adjustdate(dt, calendar, Following())

    # si cambia el mes o pasamos de mitad de mes, buscamos para atras
    if month(dt′) != month(dt) || (dayofmonth(dt) <= 15 && dayofmonth(dt′) > 15)
        return adjustdate(dt, calendar, Preceding())
    else
        return dt′
    end
end

function adjustdate(dt::Date, calendar::BusinessCalendar, ::Nearest)

    dt1 = dt2 = dt

    # loop until the first holiday is found in any direction
    while isholiday(dt1, calendar) && isholiday(dt2, calendar)
        dt1 += Day(1)
        dt2 -= Day(1)
    end

    # defaults to dt1 if both dt1 and dt2 are business days
    return isholiday(dt1, calendar) ? dt2 : dt1
end

"""
    advance(dt::Date, step::DatePeriod, calendar::BusinessCalendar, [convention::BusinessDayConvention = Following()])

Advances the given date `dt`, `step` number of days and returns the result. `step` can be
either a [`DatePeriod`](@ref) or a [`BusinessDatePeriod`](@ref). In the first case,
the date advances using calendar days and if it falls in a holiday (i.e., a non business
day), it is adjusted using the `convention`. On the second case, the date advances using
business days, so it is expected that `step` can be converted to [`BusinessDay`](@ref). It
is important to note that if the provided step is either `0 days` or `0 businessdays` and
`dt` is a holiday, it will be adjusted using the `convention`.

```jldoctest; setup = :(using DayCounters; using Dates)
julia> dt = Date(2001, 12, 26)
2001-12-26

julia> advance(dt, Day(4), ArgentinaCalendar())
2002-01-02

julia> advance(dt, BusinessDay(4), ArgentinaCalendar())
2002-01-03

julia> dt = Date(2002, 1, 1)
2002-01-01

julia> advance(dt, Day(0), ArgentinaCalendar())
2002-01-02

julia> advance(dt, BusinessDay(0), ArgentinaCalendar())
2002-01-02
```
"""
function advance end

# default
advance(dt::Date, step::Period, calendar::BusinessCalendar, convention::BusinessDayConvention=Following()) =
    advance(dt, step, calendar, convention)

function advance(
    dt::Date, step::BusinessDatePeriod, calendar::BusinessCalendar, convention::BusinessDayConvention
)

    # business days to advance
    n = Dates.value(convert(BusinessDay, step))

    if iszero(n)
        # si me pasan 0 businessday, ajusto
        return adjustdate(dt, calendar, convention)
    end

    # para donde nos movemos?
    direction = n > 0 ? 1 : -1

    while !iszero(n)

        # me muevo un dia
        dt += Day(direction)

        # pero si es holiday, me sigo moviendo hasta llegar a un business
        while isholiday(dt, calendar)
            dt += Day(direction)
        end

        # proximo caso
        n -= direction
    end

    return dt
end

function advance(
    date::Date, dt::DatePeriod, calendar::BusinessCalendar, convention::BusinessDayConvention
)
  # advance calendar days and return the adjusted date
  return adjustdate(date + dt, calendar, convention)
end

# esta no se si exportarla... porque es semejante a daycount (podria tener el tema de cache)
function businessdaysbetween(
    from::Date,
    to::Date,
    calendar::BusinessCalendar,
    includefirst::Bool = true,
    includelast::Bool = false
)

    bd = 0

    if from != to

        # para donde nos movemos?
        direction = from < to ? 1 : -1

        # contamos incluyendo extremos
        bd = sum(isbusinessday(x, calendar) for x = from:Day(direction):to)

        # eliminamos primer extremo si corresponde
        if isbusinessday(from, calendar) && !includefirst
            bd -= 1
        end

        # eliminamos segundo extremo si corresponde
        if isbusinessday(to, calendar) && !includelast
            bd -= 1
        end

        # cambiamos el signo si corresponde
        if (from > to)
            bd = -bd
        end

    elseif includefirst && includelast && isbusinessday(from, calendar)
        bd = 1
    end

    return bd
end
