
@doc raw"""
    ArgentinaCalendar

Buenos Aires, Argentina, stock exchange calendar.
"""
struct ArgentinaCalendar <: WesternCalendar end

function isbusinessday(date::Date, calendar::ArgentinaCalendar)
    y, m, d = yearmonthday(date)
    w = dayofweek(date)

    dd = dayofyear(date)
    em = eastermonday(y, calendar)

    # TODO: la realidad es que hay que agregar cosas aqui
    if (
        isweekend(w)
        # New Year's Day
        ||
        (m, d) == (January, 1)
        # Holy Thursday
        ||
        (dd == em - 4)
        # Good Friday
        ||
        (dd == em - 3)
        # Labour Day
        ||
        (m, d) == (May, 1)
        # May Revolution
        ||
        (m, d) == (May, 25)
        # Death of General Manuel Belgrano
        ||
        ((15 <= d <= 21) && w == Monday && m == June)
        # Independence Day
        ||
        (m, d) == (July, 9)
        # Death of General José de San Martín
        ||
        ((15 <= d <= 21) && w == Monday && m == August)
        # Columbus Day or Day of Respect for Cultural Diversity
        ||
        ((d == 10 || d == 11 || d == 12 || d == 15 || d == 16) && w == Monday && m == October)
        # Immaculate Conception
        ||
        (m, d) == (December, 8)
        # Christmas
        ||
        (m, d) == (December, 25)
        # New Year's Eve
        ||
        (m, d) == (December, 31)
    )
        return false
    end

    return true
end
