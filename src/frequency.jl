# supertype
abstract type Frequency end

"""
    NoFrequency

Null frequency.
"""
struct NoFrequency <: Frequency end

"""
    Once

Only once, e.g., a zero-coupon.
"""
struct Once <: Frequency end

"""
    Annual

Once a year.
"""
struct Annual <: Frequency end

"""
    Semiannual

Twice a year.
"""
struct Semiannual <: Frequency end

"""
    EveryFourthMonth

Every four months.
"""
struct EveryFourthMonth <: Frequency end

"""
    Quarterly

Every three months.
"""
struct Quarterly <: Frequency end

"""
    Bimonthly

Every two months.
"""
struct Bimonthly <: Frequency end

"""
    Monthly

Once a month.
"""
struct Monthly <: Frequency end

"""
    EveryFourthWeek

Every four weeks.
"""
struct EveryFourthWeek <: Frequency end

"""
    Biweekly

Every two weeks.
"""
struct Biweekly <: Frequency end

"""
    Weekly

Once a week.
"""
struct Weekly <: Frequency end

"""
    Daily

Once a day.
"""
struct Daily <: Frequency end

# FIXME: yo a esta la llamaria UnknowFrequency
"""
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
