
# check out, a ver si sirve
# https://github.com/pazzo83/QuantLib.jl/blob/master/src/time/tenor_period.jl

period(f::NoFrequency) = Day(0)

period(f::Once) = Year(0) # Year(value(f))

period(f::Annual) = Year(1) # Year(value(f))

period(f::Semiannual) = Month(12 / value(f))

period(f::EveryFourthMonth) = Month(12 / value(f))

period(f::Quarterly) = Month(12 / value(f))

period(f::Bimonthly) = Month(12 / value(f))

period(f::Monthly) = Month(12 / value(f))

period(f::EveryFourthWeek) = Week(52 / value(f))

period(f::Biweekly) = Week(52 / value(f))

period(f::Weekly) = Week(52 / value(f))

period(f::Daily) = Day(1)

period(f::OtherFrequency) = f.period

# default
# period(f::Frequency) = error unknown frequency
