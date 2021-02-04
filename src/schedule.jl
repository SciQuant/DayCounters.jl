
# abstract type DateGenerationRule end

# TODO:
#  - Un caso que Rodri menciono es tener un vector de Dates.CompoundPeriod para avanzar
# en lugar de solo tener Dates.Period. No se que tanto se utilice eso, pero hay que verlo.
#  - Strata and QuantLib use some conventions for schedule building. See for example,
# http://strata.opengamma.io/schedules/. Nosotros podemos construir esos objetos con el
# dispatch de Tenors::Vector{<:DatePeriod}, pero por ahi conviene usar sus convenciones de
# Stubs porque puede que sean conocidas en la industria.

struct Schedule{C<:Union{BusinessCalendar,Nothing},B<:Union{BusinessDayConvention,Nothing}}
    dates::Vector{Date}
    calendar::C
    convention::B
end

function Schedule(
    from::Date,
    to::Date,
    δtenor::DatePeriod,
    calendar::BusinessCalendar,
    convention::BusinessDayConvention
)
    adjustedfrom = adjustdate(from, calendar, convention)
    adjustedto = adjustdate(to, calendar, convention)

    # first date
    dates = Date[adjustedfrom, ]

    i = 1
    while true
        date = advance(dates[i], δtenor, calendar, convention)
        if date < adjustedto
            push!(dates, date)
        else
            break
        end
        i += 1
    end

    # last date
    push!(dates, adjustedto)

    return Schedule(dates, calendar, convention)
end

# build irregular schedules
function Schedule(
    referenceDate::Date,
    δtenors::Vector{<:DatePeriod},
    calendar::BusinessCalendar,
    convention::BusinessDayConvention,
    fromt0::Bool = false # or true?
)
    dates = Date[adjustdate(referenceDate, calendar, convention), ]
    for (i, δtenor) in enumerate(δtenors)
        date = fromt0 ?
            advance(dates[begin], δtenor, calendar, convention) :
            advance(dates[i], δtenor, calendar, convention)
        push!(dates, date)
    end
    return Schedule(dates, calendar, convention)
end

# me faltan los metodos si paso Frequencies: Annual(), Semiannual()
function Schedule(
    from::Date, to::Date, δtenorf::Frequency, calendar::BusinessCalendar, convention::BusinessDayConvention
)
    return Schedule(from, to, period(δtenorf), calendar, convention)
end

function Schedule(
    referenceDate::Date,
    δtenorf::Vector{<:Frequency},
    calendar::BusinessCalendar,
    convention::BusinessDayConvention
)
    return Schedule(referenceDate, period.(δtenorf), calendar, convention)
end

# constructor for schedules that do not depend on business days calendars and conventions.
Schedule(dates::Vector{Date}) = Schedule(dates, nothing, nothing)

function yearfraction(
    schedule::Schedule, effectiveDate::Date, convention::DayCountConvention
)
    dates = schedule.dates

    yf1 = yearfraction(effectiveDate, dates[begin], convention)
    yfs = Vector{typeof(yf1)}(undef, length(dates))

    yfs[1] = yf1
    for i in 2:length(dates)
        yfs[i] = yfs[i - 1] + yearfraction(dates[i - 1], dates[i], convention)
    end

    return yfs
end

yearfraction(schedule::Schedule, convention::DayCountConvention) =
    yearfraction(schedule, schedule.dates[begin], convention)