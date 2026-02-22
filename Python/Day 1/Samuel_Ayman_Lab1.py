#day 1 python code 

#Task 2
message='First day in python'
print(message)

#Task 3
fav_num=1
print(f'My favourite number is {fav_num}')

#Task 4
radious=5
volume = (4/3)*(3.14*radious**3) #radious in centimeters and volume in cubic centimeters
print(f'sphere volume is : {volume}')

#Task 5
x=27
y=15
print(f'{x}+{y} = {x+y}')
print(f'{x}-{y} = {x-y}')
print(f'{x}*{y} = {x*y}')
print(f'{x}/{y} = {x/y}')

#Task 6
days=int(input('enter number of days : '))
no_of_seconds=days *24*3600
print(f'seconds in {days} days is equal : {no_of_seconds}')

#Task 7
std_no=int(input('How manty students in the course? '))
group_size=int(input('Desired group size? '))
no_groups=abs( (-std_no)//group_size)
print(f'No of groups formed {no_groups}')
