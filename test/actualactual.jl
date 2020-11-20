# ActualActual day count convention
# From ISDA, International Swaps and Derivatives Association, Inc:
#   The Actual/Actual day count fraction.
using DayCounters
using Dates
using Test

# a) Semi-annual payments
d1 = Date(2003, Nov, 1)
d2 = Date(2003, Dec, 31)
d3 = Date(2004, May, 1)

@test yearfraction(d1, d3, ISDAActualActual()) ≈ 0.49772 atol = 0.00001
@test_broken yearfraction(d1, d3, ISMAActualActual()) ≈ 0.5
@test yearfraction(d1, d3, AFBActualActual()) ≈ 0.49727 atol = 0.00001

# b) Short first calculation period
d1 = Date(1998, Jul, 1)
d2 = Date(1999, Feb, 1)
d3 = Date(1999, Jul, 1)
d4 = Date(1999, Dec, 31)
d5 = Date(2000, Jul, 1)

# first period
@test yearfraction(d2, d3, ISDAActualActual()) ≈ 0.41096 atol = 0.00001
@test_broken yearfraction(d2, d3, ISMAActualActual()) ≈ 0.41096
@test yearfraction(d2, d3, AFBActualActual()) ≈ 0.41096 atol = 0.00001

# second period
@test yearfraction(d3, d5, ISDAActualActual()) ≈ 1.00138 atol = 0.00001
@test_broken yearfraction(d3, d5, ISMAActualActual()) ≈ 1.
@test yearfraction(d3, d5, AFBActualActual()) ≈ 1.

# c) Long first calculation period
d1 = Date(2002, Jul, 15)
d2 = Date(2002, Aug, 15)
d3 = Date(2003, Jan, 15)
d4 = Date(2003, Jul, 15)
d5 = Date(2004, Jan, 15)

# first period
@test yearfraction(d2, d4, ISDAActualActual()) ≈ 0.91507 atol = 0.00001
@test_broken yearfraction(d2, d4, ISMAActualActual()) ≈ 0.91576 atol = 0.00001
@test yearfraction(d2, d4, AFBActualActual()) ≈ 0.91507 atol = 0.00001

# second period
@test yearfraction(d4, d5, ISDAActualActual()) ≈ 0.50400 atol = 0.00001
@test_broken yearfraction(d4, d5, ISMAActualActual()) ≈ 0.50000
@test yearfraction(d4, d5, AFBActualActual()) ≈ 0.50411 atol = 0.00001

# d) Short final calculation period
d1 = Date(1999, Jul, 30)
d2 = Date(1999, Dec, 31)
d3 = Date(2000, Jan, 30)
d4 = Date(2000, Jun, 30)
d5 = Date(2000, Jul, 30)

# penultimate period
@test yearfraction(d1, d3, ISDAActualActual()) ≈ 0.50389 atol = 0.00001
@test_broken yearfraction(d1, d3, ISMAActualActual()) ≈ 0.50000
@test yearfraction(d1, d3, AFBActualActual()) ≈ 0.50411 atol = 0.00001

# final period
@test yearfraction(d3, d4, ISDAActualActual()) ≈ 0.41530 atol = 0.00001
@test_broken yearfraction(d3, d4, ISMAActualActual()) ≈ 0.41758 atol = 0.00001
@test yearfraction(d3, d4, AFBActualActual()) ≈ 0.41530 atol = 0.00001

# e) Long final calculation period
d1 = Date(1999, Nov, 30)
d2 = Date(1999, Dec, 31)
d3 = Date(2000, Feb, 29)
d4 = Date(2000, Apr, 30)
d5 = Date(2000, May, 31)

@test yearfraction(d1, d4, ISDAActualActual()) ≈ 0.41554 atol = 0.00001
@test_broken yearfraction(d1, d4, ISMAActualActual()) ≈ 0.41776 atol = 0.00001
@test yearfraction(d1, d4, AFBActualActual()) ≈ 0.41530 atol = 0.00001
