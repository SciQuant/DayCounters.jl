
"""
    TARGETCalendar

TARGET calendar (European Central Bank).
"""
struct TARGETCalendar <: WesternCalendar end

function isbusinessday(date::Date, calendar::TARGETCalendar)
    y, m, d = yearmonthday(date)
    w = dayofweek(date)

    dd = dayofyear(date)
    em = eastermonday(y, calendar)

    if (
        isweekend(w)
        # New Year's Day
        ||
        (d == 1 && m == January)
        # Good Friday
        ||
        (dd == em - 3 && y >= 2000)
        # Easter Monday
        ||
        (dd == em && y >= 2000)
        # Labour Day
        ||
        (d == 1 && m == May && y >= 2000)
        # Christmas
        ||
        (d == 25 && m == December)
        # Day of Goodwill
        ||
        (d == 26 && m == December && y >= 2000)
        # December 31st, 1998, 1999, and 2001 only
        ||
        (d == 31 && m == December && (y == 1998 || y == 1999 || y == 2001))
    )
        return false
    end

    return true
end
