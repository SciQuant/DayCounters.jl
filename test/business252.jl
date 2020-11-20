using DayCounters
using Dates
using Test

# definamos un calendario
calendar = ArgentinaCalendar()

# 1. podemos ajustar un feriado
d = Date(2020, Jan, 1)
@test adjustdate(d, calendar, Unadjusted()) == d

d = Date(2019, Dec, 31)
@test adjustdate(d, calendar, Following()) == Date(2020, Jan, 2)
@test adjustdate(d, calendar, ModifiedFollowing()) == Date(2019, Dec, 30)
@test adjustdate(d, calendar, HalfMonthModifiedFollowing()) == Date(2019, Dec, 30)

d = Date(2019, Dec, 14)
@test adjustdate(d, calendar, HalfMonthModifiedFollowing()) == Date(2019, Dec, 13)

d = Date(2020, Jan, 1)
@test adjustdate(d, calendar, Preceding()) == Date(2019, Dec, 30)
@test adjustdate(d, calendar, ModifiedPreceding()) == Date(2020, Jan, 2)

d = Date(2020, Dec, 31)
@test adjustdate(d, calendar, Nearest()) == Date(2020, Dec, 30)

d = Date(2020, Jan, 1)
@test adjustdate(d, calendar, Nearest()) == Date(2020, Jan, 2)

# 2. podemos avanzar calendar periods or business periods
d = Date(2019, Dec, 30)
@test advance(d, Day(2), calendar) == Date(2020, Jan, 2) # avanza dias calendario y ajusta el final
@test advance(d, BusinessDay(2), calendar) == Date(2020, Jan, 3) # avanza solo contando business

@test advance(d, Week(1), calendar) == Date(2020, Jan, 6)
@test advance(d, BusinessWeek(1), calendar) == Date(2020, Jan, 8)

@test advance(d, BusinessDay(5), calendar) == advance(d, BusinessWeek(1), calendar)
# @test advance(d, BusinessDay(21), calendar) == advance(d, BusinessMonth(1), calendar)

# from QuantLib test-suite/daycounters.cpp
calendar = BrazilSettlement()
daycounter = Business252(calendar)

dates = Date[]
push!(dates, Date(2002, February, 1))
push!(dates, Date(2002, February, 4))
push!(dates, Date(2003, May, 16))
push!(dates, Date(2003, December, 17))
push!(dates, Date(2004, December, 17))
push!(dates, Date(2005, December, 19))
push!(dates, Date(2006, January, 2))
push!(dates, Date(2006, March, 13))
push!(dates, Date(2006, May, 15))
push!(dates, Date(2006, March, 17))
push!(dates, Date(2006, May, 15))
push!(dates, Date(2006, July, 26))
push!(dates, Date(2007, June, 28))
push!(dates, Date(2009, September, 16))
push!(dates, Date(2016, July, 26))

expected = [
  0.0039682539683, 1.2738095238095, 0.6031746031746,  0.9960317460317, 1.0000000000000,
  0.0396825396825, 0.1904761904762, 0.1666666666667, -0.1507936507937, 0.1507936507937,
  0.2023809523810, 0.9126984126980, 2.2142857142860,  6.84126984127
]

let
  for i in 1:length(dates)-1
    @test yearfraction(dates[i], dates[i+1], daycounter) ≈ expected[i] atol = 1e-12
  end
end


