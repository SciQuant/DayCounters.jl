
"""
    UnitedStatesCalendar

Supertype for United States calendars.
"""
struct UnitedStatesCalendar <: WesternCalendar
    t::MarketCalendar
end

"""
    Settlement

Calendar including public holidays (see: http://www.opm.gov/fedhol/).
"""
struct Settlement <: MarketCalendar end

"""
    NYSE

Stock exchange calendar (data from http://www.nyse.com).
"""
struct NYSE <: MarketCalendar end

"""
    GovernmentBond

Government bond market calendar (data from http://www.bondmarkets.com).
"""
struct GovernmentBond <: MarketCalendar end

"""
    NERC

North American Energy Reliability Council calendar (data from
http://www.nerc.com/~oc/offpeaks.html):
"""
struct NERC <: MarketCalendar end

"""
    LiborImpact

to be done.
"""
struct LiborImpact <: MarketCalendar end

"""
    FederalReserve

to be done.
"""
struct FederalReserve <: MarketCalendar end

function iswashingtonbirthday(d::Int64, m::Int64, y::Int64, w::Int64)
    if y >= 1971
        # third Monday in February
        return (d >= 15 && d <= 21) && w == Monday && m == February
    else
        # February 22nd, possily adjusted
        return (d == 22 || (d == 23 && w == Monday) || (d == 21 && w == Friday)) && m == February
    end
end

function ismemorialday(d::Int64, m::Int64, y::Int64, w::Int64)
    if y >= 1971
        # last Monday in May
        return d >= 25 && w == Monday && m == May
    else
        # May 30th, possibly adjusted
        return (d == 30 || (d == 31 && w == Monday) || (d == 29 && w == Friday)) && m == May
    end
end

function islaborday(d::Int64, m::Int64, y::Int64, w::Int64)
    # first Monday in September
    return d <= 7 && w == Monday && m == September
end

function iscolumbusday(d::Int64, m::Int64, y::Int64, w::Int64)
    # second Monday in October
    return (d >= 8 && d <= 14) && w == Monday && m == October && y >= 1971
end

function isVeteransDay(d::Int64, m::Int64, y::Int64, w::Int64)
    if y <= 1970 || y >= 1978
        # November 11th, adjusted
        return (d == 11 || (d == 12 && w == Monday) || (d == 10 && w == Friday)) && m == November
    else
        # fourth Monday in October
        return (d >= 22 && d <= 28) && w == Monday && m == October
    end
end

function isveteransdaynosaturday(d::Int64, m::Int64, y::Int64, w::Int64)
    if y <= 1970 || y >= 1978
        # November 11th, adjusted, but no Saturday to Friday
        return (d == 11 || (d == 12 && w == Monday)) && m == November
    else
        # fourth Monday in October
        return (d >= 22 && d <= 28) && w == Monday && m == October
    end
end

isbusinessday(date::Date, calendar::UnitedStatesCalendar) = isbusinessday(date, calendar.t)

function isbusinessday(date::Date, ::FederalReserve)
    y, m, d = yearmonthday(date)
    w = dayofweek(date)

    if (
        isweekend(w)
        # New Year's Day (possibly moved to Monday if on Sunday)
        || ((d == 1 || (d == 2 && w == Monday)) && m == January)
        # Martin Luther King's birthday (third Monday in January)
        || ((d >= 15 && d <= 21) && w == Monday && m == January && y >= 1983)
        # Washington's birthday (third Monday in February)
        || iswashingtonbirthday(d, m, y, w)
        # Memorial Day (last Monday in May)
        || ismemorialday(d, m, y, w)
        # Independence Day (Monday if Sunday)
        || ((d == 4 || (d == 5 && w == Monday)) && m == July)
        # Labor Day (first Monday in September)
        || islaborday(d, m, y, w)
        # Columbus Day (second Monday in October)
        || iscolumbusday(d, m, y, w)
        # Veteran's Day (Monday if Sunday)
        || isveteransdaynosaturday(d, m, y, w)
        # Thanksgiving Day (fourth Thursday in November)
        || ((d >= 22 && d <= 28) && w == Thursday && m == November)
        # Christmas (Monday if Sunday)
        || ((d == 25 || (d == 26 && w == Monday)) && m == December))
        return false
    end
    return true
end