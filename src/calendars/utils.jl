
isweekend(w::Int64) = w == Saturday || w == Sunday
isweekend(d::Date) = isweekend(dayofweek(d))

isweekday(d::Union{Date,Int64}) = !isweekend(d)

# general, not strict, usage
century(y::Int64) = y > 0 ? div(y, 100) + 1 : throw(DomainError("outside domain!"))

julian2gregoriandate(date::Date) = date + Day(gregorianjulian_diff(year(date)))
gregorianjulian_diff(y::Int64) = div(3 * century(y), 4) - 2

# auxiliary computations for easter
function easter(y::Int64, ::Union{Type{WesternCalendar},WesternCalendar})

    # Using Meeus/Jones/Butcher (anonymous) algorithm from Astronomical Algorithms, 2nd
    # Edition, Jean Meeus, pg. 67
    a = mod(y, 19)
    b = div(y, 100)
    c = mod(y, 100)
    d = div(b, 4)
    e = mod(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    h = mod(19a + b - d - g + 15, 30)
    i = div(c, 4)
    k = mod(c, 4)
    l = mod(32 + 2e + 2i - h - k, 7)
    m = div(a + 11h + 22l, 451)

    day = mod(h + l - 7m + 114, 31) + 1
    month = div(h + l - 7m + 114, 31)

    # returns easter Sunday
    return Date(y, month, day)
end

function easter(y::Int64, ::Union{Type{OrthodoxCalendar},OrthodoxCalendar})

    # Using Meeus algorithm from Astronomical Algorithms, 2nd Edition, Jean Meeus, pg. 69
    a = mod(y, 4)
    b = mod(y, 7)
    c = mod(y, 19)
    d = mod(19c + 15, 30)
    e = mod(2a + 4b - d + 34, 7)

    day = mod(d + e + 114, 31) + 1
    month = div(d + e + 114, 31)

    # in Julian calendar
    juliandate = Date(y, month, day)

    # returns easter Sunday
    return julian2gregoriandate(juliandate)
end

# cache to avoid computations
const EASTER_FROM = 1900
const EASTER_TO = 2200
const EasterMondayWestern = [dayofyear(easter(y, WesternCalendar)) + 1 for y in EASTER_FROM:EASTER_TO]
const EasterMondayOrthodox = [dayofyear(easter(y, OrthodoxCalendar)) + 1 for y in EASTER_FROM:EASTER_TO]

eastermonday(y::Int64, ::WesternCalendar) = EasterMondayWestern[y - EASTER_FROM + 1]
eastermonday(y::Int64, ::OrthodoxCalendar) = EasterMondayOrthodox[y - EASTER_FROM + 1]
