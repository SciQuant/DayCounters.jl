# supertype
abstract type Frequency end

@doc raw"""
    NoFrequency

Null frequency.
"""
struct NoFrequency <: Frequency end

@doc raw"""
    Once

Only once, e.g., a zero-coupon.
"""
struct Once <: Frequency end

@doc raw"""
    Annual

Once a year.
"""
struct Annual <: Frequency end

@doc raw"""
    Semiannual

Twice a year.
"""
struct Semiannual <: Frequency end

@doc raw"""
    EveryFourthMonth

Every four months.
"""
struct EveryFourthMonth <: Frequency end

@doc raw"""
    Quarterly

Every three months.
"""
struct Quarterly <: Frequency end

@doc raw"""
    Bimonthly

Every two months.
"""
struct Bimonthly <: Frequency end

@doc raw"""
    Monthly

Once a month.
"""
struct Monthly <: Frequency end

@doc raw"""
    EveryFourthWeek

Every four weeks.
"""
struct EveryFourthWeek <: Frequency end

@doc raw"""
    Biweekly

Every two weeks.
"""
struct Biweekly <: Frequency end

@doc raw"""
    Weekly

Once a week.
"""
struct Weekly <: Frequency end

@doc raw"""
    Daily

Once a day.
"""
struct Daily <: Frequency end

# FIXME: yo a esta la llamaria UnknowFrequency
@doc raw"""
    OtherFrequency

Some other unknown frequency.
"""
struct OtherFrequency <: Frequency end
# struct OtherFrequency <: Frequency
#   value::Int64
#   OtherFrequency(value = 999) = new(value)
# end
# struct OtherFrequency{T<:DatePeriod} <: Frequency
#   period::T
# end
# OtherFrequency(period::T = Day(999)) where {T<:DatePeriod} = OtherFrequency{T}(period)

const frequencies = (
    (:NoFrequency, "No-Frequency", -1),
    (:Once, "Once", 0),
    (:Annual, "Annual", 1),
    (:Semiannual, "Semiannual", 2),
    (:EveryFourthMonth, "Every-fourth-month", 3),
    (:Quarterly, "Quarterly", 4),
    (:Bimonthly, "Bimonthly", 6),
    (:Monthly, "Monthly", 12),
    (:EveryFourthWeek, "Every-fourth-week", 13),
    (:Biweekly, "Biweekly", 26),
    (:Weekly, "Weekly", 52),
    (:Daily, "Daily", 365),
    (:OtherFrequency, "Other-frequency", 999)
)

for (x, y, z) in frequencies
  @eval Base.show(io::IO, ::$x) = print($y)
  @eval value(::$x) = $z
end

# default value as -1
value(::Frequency) = -1
