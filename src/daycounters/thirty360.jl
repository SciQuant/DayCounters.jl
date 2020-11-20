
@doc raw"""
    Thirty360

Day count convention that can be calculated according to to US, European, Italian or German
conventions.
"""
abstract type Thirty360 <: DayCountConvention end

@doc raw"""
    USAThirty360

Also known as "30/360", "360/360", or "Bond Basis" is a [`Thirty360`](@ref) subtype day
count convention. If the starting date is the 31st of a month, it becomes equal to the 30th
of the same month. If the ending date is the 31st of a month and the starting date is
earlier than the 30th of a month, the ending date becomes equal to the 1st of the next
month, otherwise the ending date becomes equal to the 30th of the same month.
"""
struct USAThirty360 <: Thirty360 end

@doc raw"""
    BondBasisThirty360

Is an alias for [`USAThirty360`](@ref).
"""
const BondBasisThirty360 = USAThirty360

@doc raw"""
    EuropeanThirty360

Also known as "30E/360", or "Eurobond Basis" is a [`Thirty360`](@ref) subtype day count
convention. Starting dates or ending dates that occur on the 31st of a month become equal to
the 30th of the same month.
"""
struct EuropeanThirty360 <: Thirty360 end

@doc raw"""
    EurobondBasisThirty360

Is an alias for [`EuropeanThirty360`](@ref).
"""
const EurobondBasisThirty360 = EuropeanThirty360

@doc raw"""
    ItalianThirty360

Is a [`Thirty360`](@ref) subtype day count convention. Starting dates or ending dates that
occur on February and are grater than 27 become equal to 30 for computational sake.
"""
struct ItalianThirty360 <: Thirty360 end

@doc raw"""
    GermanThirty360([islastperiod = false])

Also known as "30E/360 ISDA" is a [`Thirty360`](@ref) subtype day count convention. Starting
dates or ending dates that occur on the last day of February become equal to 30 for
computational sake, except for the termination date.
"""
struct GermanThirty360 <: Thirty360
    islastperiod::Bool
    GermanThirty360(islastperiod = false) = new(islastperiod)
end

daysperyear(::Thirty360) = 360

function daycount(y1::Int64, y2::Int64, m1::Int64, m2::Int64, d1::Int64, d2::Int64, ::Thirty360)
    return 360 * (y2 - y1) + 30 * (m2 - m1 - 1) + max(0 , 30 - d1) + min(30, d2)
end

yearfraction(dt1::Date, dt2::Date, c::Thirty360) = daycount(dt1, dt2, c) / daysperyear(c)

function daycount(dt1::Date, dt2::Date, c::USAThirty360)
    y1, m1, d1 = yearmonthday(dt1)
    y2, m2, d2 = yearmonthday(dt2)

    if d2 == 31 && d1 < 30
        d2 = 1
        m2 += 1
    end

    return daycount(y1, y2, m1, m2, d1, d2, c)
end

function daycount(dt1::Date, dt2::Date, c::EuropeanThirty360)
    y1, m1, d1 = yearmonthday(dt1)
    y2, m2, d2 = yearmonthday(dt2)

    return daycount(y1, y2, m1, m2, d1, d2, c)
end

function daycount(dt1::Date, dt2::Date, c::ItalianThirty360)
    y1, m1, d1 = yearmonthday(dt1)
    y2, m2, d2 = yearmonthday(dt2)

    if m1 == February && d1 > 27
        d1 = 30
    end

    if m2 == February && d2 > 27
        d2 = 30
    end

    return daycount(y1, y2, m1, m2, d1, d2, c)
end

function daycount(dt1::Date, dt2::Date, c::GermanThirty360)
    y1, m1, d1 = yearmonthday(dt1)
    y2, m2, d2 = yearmonthday(dt2)

    if (m1, d1) == (February, 28 + isleapyear(y1))
        d1 = 30
    end

    if !c.islastperiod && (m2, d2) == (February, 28 + isleapyear(y2))
        d2 = 30
    end

    return daycount(y1, y2, m1, m2, d1, d2, c)
end

Base.show(io::IO, ::USAThirty360) = print(io, "30/360 (Bond Basis)")
Base.show(io::IO, ::EuropeanThirty360) = print(io, "30E/360 (Eurobond Basis)")
Base.show(io::IO, ::ItalianThirty360) = print(io, "30/360 (Italian)")
Base.show(io::IO, ::GermanThirty360) = print(io, "30/360 (German)")
