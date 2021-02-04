
"""
    BrazilCalendar

Brazilian calendar.
"""
abstract type BrazilCalendar <: WesternCalendar end

"""
    BrazilSettlement

Calendar including public holidays.
"""
struct BrazilSettlement <: BrazilCalendar end

"""
    BrazilExchange

Holidays for the Bovespa stock exchange.
"""
struct BrazilExchange <: BrazilCalendar end

function isbusinessday(date::Date, calendar::BrazilSettlement)
    y, m, d = yearmonthday(date)
    w = dayofweek(date)

    dd = dayofyear(date)
    em = eastermonday(y, calendar)

    if (
        isweekend(w)
        # New Year's Day
        || (m, d) == (January, 1)
        # Tiradentes Day
        || (m, d) == (April, 21)
        # Labor Day
        || (m, d) == (May, 1)
        # Independence Day
        || (m, d) == (September, 7)
        # Nossa Sra. Aparecida Day
        || (m, d) == (October, 12)
        # All Souls Day
        || (m, d) == (November, 2)
        # Republic Day
        || (m, d) == (November, 15)
        # Christmas
        || (m, d) == (December, 25)
        # Passion of Christ
        || (dd == em - 3)
        # Carnival
        || (dd == em - 49 || dd == em - 48)
        # Corpus Christi
        || (dd == em + 59)
    )
        return false
    end
    return true
end

function isbusinessday(date::Date, calendar::BrazilExchange)
    y, m, d = yearmonthday(date)
    w = dayofweek(date)

    dd = dayofyear(date)
    em = eastermonday(y, calendar)

    # TODO: do it

    return nothing
end

