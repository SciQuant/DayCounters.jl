
@doc raw"""
    ActualActual

Day count convention that can be calculated according to the ISDA, ISMA and AFB conventions.
The difference between these conventions lie in the computation of the denominator. The
numerator is, in all cases, equal to the actual number of days between two dates, including
the first one and excluding the last one.

For more details, please refer to
https://www.isda.org/a/pIJEE/The-Actual-Actual-Day-Count-Fraction-1999.pdf.
"""
abstract type ActualActual <: DayCountConvention end

@doc raw"""
    ISDAActualActual

Also known as "Actual/Actual (Historical)", "Actual/Actual", "Act/Act", and according to
ISDA also "Actual/365", "Act/365", and "A/365", is a [`ActualActual`](@ref) subtype day
count convention where the denominator varies depending on whether a portion of relevant
calculation period falls within a leap year (for the portion of the calculation period
falling within a leap year, the denominator is 366 and for the portion falling outside a
leap year, the denominator is 365).
"""
struct ISDAActualActual <: ActualActual end

@doc raw"""
    HistoricalActualActual

Is an alias for [`ISDAActualActual`](@ref).
"""
const HistoricalActualActual = ISDAActualActual

@doc raw"""
    Actual365

Is an alias for [`ISDAActualActual`](@ref).
"""
const Actual365 = ISDAActualActual

@doc raw"""
    ISMAActualActual

Also known as "Actual/Actual (Bond)" is a [`ActualActual`](@ref) subtype day count
convention where the denominator is the actual number of days in the period...
"""
struct ISMAActualActual <: ActualActual end

@doc raw"""
    BondActualActual

Is an alias for [`ISMAActualActual`](@ref).
"""
const BondActualActual = ISMAActualActual

@doc raw"""
    AFBActualActual

Also known as "Actual/Actual (Euro)" is a [`ActualActual`](@ref) subtype day count
convention where the denominator is either 365 (if the calculation period does not contain
29th February) or 366 (if the calculation period includes 29th February). For periods longer
than one year... to be completed.
"""
struct AFBActualActual <: ActualActual end

@doc raw"""
    EuroActualActual

Is an alias for [`AFBActualActual`](@ref).
"""
const EuroActualActual = AFBActualActual

# the numerator is the same for all ActualActual subtypes
daycount(dt1::Date, dt2::Date, ::ActualActual) = Dates.value(dt2 - dt1)

daysperyear(dt) = daysinyear(dt)

function yearfraction(dt1::Date, dt2::Date, c::ISDAActualActual)

    if dt1 == dt2
        return 0.
    end

    # lo necesitamos por el maneje de abajo
    if dt1 > dt2
        return -yearfraction(dt2, dt1, c)
    end

    y1 = year(dt1)
    y2 = year(dt2)

    sum = y2 - y1 - 1.

    sum += daycount(dt1, Date(y1 + 1, 1, 1), c) / daysperyear(dt1)
    sum += daycount(Date(y2, 1, 1), dt2, c) / daysperyear(dt2)

    return sum
end

function yearfraction(dt1::Date, dt2::Date, c::ISMAActualActual)
    # to be done. al parecer tengo que tener la cantidad de cupones por año... y esto lo voy
    # a tener que estimar de alguna forma creo. ir viendo QuantLib como lo hacen
    return nothing
    end

function yearfraction(dt1::Date, dt2::Date, c::AFBActualActual)

    if dt1 == dt2
        return 0.
    end

    # lo necesitamos por el maneje de abajo
    if dt1 > dt2
        return -yearfraction(dt2, dt1, c)
    end

    # calculamos de a periodos de un año arrancando desde el final
    dt1′ = dt2
    dt2′ = dt2
    sum = 0.
    while dt1′ > dt1

        # actualizamos el valor inicial del intervalo
        dt1′ = dt2′ - Year(1)

        # caso particular: si vengo del 28-02-xxxx y resto 1 año pero (xxxx-1) es leap, me muevo
        # al 29-02-(xxxx-1)
        if monthday(dt1′) == (February, 28) && isleapyear(dt1′)
            dt1′ += Day(1)
        end

        # si cayo por delante, sumamos 1 año entero y actualizamos dt2′ para la proxima pasada
        if dt1′ >= dt1
            sum += 1.
            dt2′ = dt1′
        end
    end

    # hasta aca llegamos y queda un periodo de menos de un año entre dt1 y dt2′. tenemos que
    # ver si contiene el 29 de Febrero o no
    den = 365.
    if isleapyear(dt2)
        leapday = Date(year(dt2), February, 29)

        if dt2′ > leapday && dt1 <= leapday
            den += 1.
        end

    elseif isleapyear(dt1)
        leapday = Date(year(dt1), February, 29)

        if dt2′ > leapday && dt1 <= leapday
            den += 1.
        end
    end

    return sum + daycount(dt1, dt2′, c) / den
end

Base.show(io::IO, ::ISDAActualActual) = print(io, "Actual/Actual (ISDA)")
Base.show(io::IO, ::ISMAActualActual) = print(io, "Actual/Actual (ISMA)")
Base.show(io::IO, ::AFBActualActual) = print(io, "Actual/Actual (AFB)")
