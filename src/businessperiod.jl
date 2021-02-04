
using Dates: divexact, CompoundPeriod
import Dates: _units, periodisless

abstract type BusinessDatePeriod <: DatePeriod end

for T in (:BusinessYear, :BusinessMonth, :BusinessWeek, :BusinessDay)
    @eval struct $T <: BusinessDatePeriod
        value::Int64
        $T(v::Number) = new(v)
    end
end

# adapted from julia base
for period in (:BusinessYear, :BusinessMonth, :BusinessWeek, :BusinessDay)
    period_str = string(period)
    accessor_str = lowercase(period_str)
    # Convenience method for show()
    @eval _units(x::$period) = " " * $accessor_str * (abs(Dates.value(x)) == 1 ? "" : "s")
    # periodisless
    @eval periodisless(x::$period, y::$period) = Dates.value(x) < Dates.value(y)
    # AbstractString parsing (mainly for IO code)
    @eval $period(x::AbstractString) = $period(Base.parse(Int64, x))
    # Period accessors
    @eval begin
        @doc """
            $($period_str)(v)

        Construct a `$($period_str)` object with the given `v` value. Input must be
        losslessly convertible to an `Int64`.
        """ $period(v)
    end
end

periodisless(::Period, ::BusinessYear) = true
periodisless(::Period, ::BusinessMonth) = true
periodisless(::BusinessYear, ::BusinessMonth) = false
periodisless(::Period, ::BusinessWeek) = true
periodisless(::BusinessYear, ::BusinessWeek) = false
periodisless(::BusinessMonth, ::BusinessWeek) = false
periodisless(::Period, ::BusinessDay) = true
periodisless(::BusinessYear, ::BusinessDay) = false
periodisless(::BusinessMonth, ::BusinessDay) = false
periodisless(::BusinessWeek, ::BusinessDay) = false

# return (next coarser period, conversion factor):
coarserperiod(::Type{BusinessDay}) = (BusinessWeek, 5)
# esta es correcta? yo por un lado quizas quiera q un mes sean 21 business days, pero no se
# aun, por ahi no quiero, es mas, creo que no quiero. Sin embargo abajo lo defini!!
# coarserperiod(::Type{BusinessMonth}) = (BusinessYear, 12)

const FixedBusinessPeriod = Union{BusinessWeek,BusinessDay}

# FixedPeriod conversions and promotion rules
const fixedbusinessperiod_conversions = [(:BusinessWeek, 5), (:BusinessDay, 1)]
for i = 1:length(fixedbusinessperiod_conversions)
    T, n = fixedbusinessperiod_conversions[i]
    N = Int64(1)
    for j = (i - 1):-1:1 # less-precise periods
        Tc, nc = fixedbusinessperiod_conversions[j]
        N *= nc
        vmax = typemax(Int64) ÷ N
        vmin = typemin(Int64) ÷ N
        @eval function Base.convert(::Type{$T}, x::$Tc)
            $vmin ≤ Dates.value(x) ≤ $vmax || throw(InexactError(:convert, $T, x))
            return $T(Dates.value(x) * $N)
        end
    end
    N = n
    for j = (i + 1):length(fixedbusinessperiod_conversions) # more-precise periods
        Tc, nc = fixedbusinessperiod_conversions[j]
        @eval Base.convert(::Type{$T}, x::$Tc) = $T(divexact(Dates.value(x), $N))
        @eval Base.promote_rule(::Type{$T}, ::Type{$Tc}) = $Tc
        N *= nc
    end
end

# los queremos? arriba los comente... no me convence. Por ahi 1 Year = 1 BusinessYear?
const OtherBusinessPeriod = Union{BusinessMonth, BusinessYear}
let vmax = typemax(Int64) ÷ 12, vmin = typemin(Int64) ÷ 12
    @eval function Base.convert(::Type{BusinessMonth}, x::BusinessYear)
        $vmin ≤ Dates.value(x) ≤ $vmax || throw(InexactError(:convert, BusinessMonth, x))
        BusinessMonth(Dates.value(x) * 12)
    end
end
Base.convert(::Type{BusinessYear}, x::BusinessMonth) = BusinessYear(divexact(Dates.value(x), 12))
Base.promote_rule(::Type{BusinessYear}, ::Type{BusinessMonth}) = BusinessMonth

# fixed is not comparable to other periods, as per discussion in issue #21378
Base.:(==)(x::FixedBusinessPeriod, y::OtherBusinessPeriod) = false
Base.:(==)(x::OtherBusinessPeriod, y::FixedBusinessPeriod) = false

Base.isless(x::FixedBusinessPeriod, y::OtherBusinessPeriod) = throw(MethodError(isless, (x, y)))
Base.isless(x::OtherBusinessPeriod, y::FixedBusinessPeriod) = throw(MethodError(isless, (x, y)))

businessdays(c::BusinessDay) = Dates.value(c)
businessdays(c::BusinessWeek) = 5 * Dates.value(c)
# businessdays(c::BusinessMonth) = 21 * Dates.value(c)
# businessdays(c::BusinessYear) = 252 * Dates.value(c)
businessdays(c::CompoundPeriod) = isempty(c.periods) ? 0.0 : sum(businessdays, c.periods)
