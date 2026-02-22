USE Company_SD

--1.	Display the Department id, name and id and the name of its manager.
SELECT Dnum , Dname , MGRSSN , Fname + ' ' + Lname AS NAME 
FROM Departments as d inner join Employee as e ON d.MGRSSN=e.SSN  

--2.	Display the name of the departments and the name of the projects under its control.
SELECT Dname, Pname 
FROM Departments as d inner join project as p ON p.Dnum=d.Dnum

--3.	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
SELECT d.*,Fname + ' ' + Lname AS Employee_depends_on 
FROM Dependent as d inner join Employee as e ON e.SSN =d.ESSN

--4.	Display the Id, name and location of the projects in Cairo or Alex city.
SELECT Pnumber, Pname,Plocation 
FROM Project 
WHERE City in ('ALEX','Cairo')

--5.	Display the Projects full data of the projects with a name starts with "a" letter.
SELECT * 
FROM Project 
WHERE Pname LIKE 'a%'

--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
SELECT Fname + ' ' + Lname AS NAME , Salary
FROM Employee 
WHERE Salary BETWEEN 1000 AND 2000 AND Dno=30

--7.	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT Fname + ' ' + Lname AS NAME 
FROM Employee e join Works_for as w ON w.ESSn=e.SSN join Project as p ON p.Pnumber=w.Pno
WHERE e.Dno =10 AND w.Hours>=10 AND p.Pname ='AL Rabwah'

--8.	Find the names of the employees who directly supervised with Kamel Mohamed.
SELECT a.Fname + ' ' + a.Lname AS NAME 
FROM Employee a , Employee b
WHERE b.SSN=a.Superssn AND b.Fname + ' ' + b.Lname='Kamel Mohamed'

--9.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
SELECT Fname + ' ' + Lname NAME, p.Pname
FROM Employee e join Works_for w ON w.ESSn=e.SSN join Project p ON p.Pnumber=w.Pno
ORDER BY p.Pname

--10.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
SELECT Pnumber,d.Dname,e.Lname,e.Address,e.Bdate
FROM Project p join Departments d on d.Dnum=p.Dnum join Employee e ON e.SSN=d.MGRSSN
WHERE p.City='Cairo'

--11.	Display All Data of the managers
SELECT * 
FROM Employee e join Departments d ON e.SSN=d.MGRSSN


--12.	Display All Employees data and the data of their dependents even if they have no dependents
SELECT * 
FROM Employee e left join Dependent d ON d.ESSN=e.SSN

--13.	Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee(Fname,Lname,SSN,Bdate,Address,Sex,Salary,Superssn,Dno)
Values('Samuel','Ayman',102672,'2002-10-09','Alex','M',3000,112233,30)

--14.	Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
INSERT INTO Employee(Fname,Lname,SSN,Bdate,Address,Sex,Dno)
Values('Michael','Mokhles',102660,'08-10-2002','Alex','M',30)

--15.	Upgrade your salary by 20 % of its last value.
update employee
set salary = salary *1.2
Where ssn=102672