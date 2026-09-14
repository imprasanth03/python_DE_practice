#1.Employee Bonus
#Input years of experience and performance rating.
#If experience ≥ 5:
#If rating ≥ 4 → 20% bonus
#Otherwise → 10% bonus
#Otherwise:
#If rating ≥ 4 → 10% bonus
#Otherwise → 5% bonus.


experience = float(input("Enter the experience:"))
rating = int(input("Enter the rating:"))
if experience >= 5:
    if rating >= 4:
        print("20% Bonus")
    else:
        print("10 Bonus")
else:
     if rating >= 4:
         print("10% Bonus")
     else:
         print("5% Bonus")

--------------------------------------------------------------------------
#2.Student Scholarship
#Input marks and family income.
#If marks ≥ 80:
#Check income.
#If income ≤ ₹3,00,000 → "Full Scholarship"
#Otherwise → "Partial Scholarship"
#Otherwise → "Not eligible"


marks = int(input("Enter the marks:"))
income = int(input("Enter the income:"))
if marks >= 80:
    if income <= 300000:
        print("Full scholarship")
    else:
        print("Partial scholarship")
else:
    print("Not eligible")

-------------------------------------------------------------------------
#3.Second Largest Number
#Input three different numbers.
#Find the second-largest number using only if statements.
#Don't use sort() or max().

a = int(input("A:"))
b = int(input("B:"))
c = int(input("C:"))
if (a > b and a < c) or (a > c and a < b):
    print("Second largest number:", a)
elif(b > a and b < c ) or (b > c and b < a):
    print("Second largest number:", b)
else:
    print("Second largest number:", c)

----------------------------------------------------------------------------
#4. Triangle Validation
#Input three sides.
#First check whether the sides can form a triangle.
#If valid:
#Check whether it is:
#Equilateral [a=b=c]
#Isosceles [a=b or b=c or a=c]
#Scalene [a != b !=c]

a = int(input("A:"))
b = int(input("B:"))
c = int(input("C:"))
if a + b > c and a + c > b and b + c > a:
    if a == b == c:
        print("Equilateral")
    elif a == b or b == c or a == c:
        print("Isosceles")
    else:
        print("Scalene")
else:
    print("Not a valid Triangle")

----------------------------------------------------------------------------
#5. ATM Withdrawal
#Input account balance and withdrawal amount.
#If withdrawal amount is positive:
#Check whether sufficient balance exists.
#If sufficient:
#Check whether the amount is a multiple of ₹100.
#If yes → "Withdrawal successful"
#Otherwise → "Enter amount in multiples of 100"
#Otherwise → "Insufficient balance"

Balance = int(input("Enter account balance:"))
withdrawal = int(input("Enter withdrawal amount:"))
if withdrawal > 0:
    if withdrawal <= Balance:
        if withdrawal % 100 == 0:
            print("withdrawal successful")
        else:
            print("Enter the amount multiple of 100")
    else:
        print("insufficient balance")
else:
    print("Enter a positive withdrawal number")

----------------------------------------------------------------------------

