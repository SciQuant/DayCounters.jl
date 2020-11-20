module DayCounters

using Dates
# import Dates: periodisless, value # est, asi es mejor no? y remuevo los Dates. El unico
# problema es que si importo value, la voy a cagar porque la estoy definiendo en frequency.jl
# y no quiero

include("frequency.jl")
include("period.jl")
include("businessperiod.jl")
include("calendars/calendar.jl")
include("daycounters/daycounter.jl")
include("schedule.jl")

# frequency.jl
export NoFrequency, Once, Annual, Semiannual, EveryFourthMonth, Quarterly, Bimonthly,
       Monthly, EveryFourthWeek, Biweekly, Weekly, Daily, OtherFrequency, value

# period.jl
export period

# businessperiod.jl
export BusinessDay, BusinessWeek, BusinessMonth, BusinessYear

# calendar.jl
export isholiday,
       isbusinessday

# <calendarname>.jl files
export ArgentinaCalendar,
       BrazilSettlement,
       BrazilExchange,
       TARGETCalendar,
       UnitedStatesCalendar,
       Settlement,
       NYSE,
       GovernmentBond,
       NERC,
       LiborImpact,
       FederalReserve

# calendar.jl
export Unadjusted,
       Following,
       ModifiedFollowing,
       Preceding,
       ModifiedPreceding,
       HalfMonthModifiedFollowing,
       Nearest,
       adjustdate,
       advance,
       businessdaysbetween

export yearfraction,
       daycount,
       dayperyear,
       Actual360,
       Actual365Fixed,
       ISDAActualActual, HistoricalActualActual, Actual365,
       ISMAActualActual, BondActualActual,
       AFBActualActual, EuroActualActual,
       USAThirty360, BondBasisThirty360,
       EuropeanThirty360, EurobondBasisThirty360,
       ItalianThirty360,
       GermanThirty360,
       Business252

# schedule.jl
export Schedule

end
