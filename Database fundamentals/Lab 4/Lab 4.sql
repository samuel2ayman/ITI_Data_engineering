use Company_SD
--1.	Display (Using Union Function)
	--a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
	--b.	 And the male dependence that depends on Male Employee.
SELECT d.Dependent_name,d.Sex
FROM Employee e INNER JOIN Dependent d ON e.SSN= d.ESSN and e.Sex='F' and d.Sex='F' 
UNION
SELECT d.Dependent_name,d.Sex
FROM Employee e INNER JOIN Dependent d ON e.SSN= d.ESSN and e.Sex='M' and d.Sex='M'

--2.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT p.Pname, SUM (w.Hours) as Total_hours_per_week
FROM Project p join Works_for w on w.Pno=p.Pnumber
GROUP BY p.Pname

--3.	Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT d.* 
FROM Departments d inner join Employee e ON e.dno =d.Dnum
WHERE e.SSN=(SELECT MIN(SSN) FROM Employee)

--4.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT d.Dname,MAX(e.Salary) as MAX_salary,MIN(e.Salary) as MIN_salary, AVG(ISNULL(e.Salary,0)) as AVG_Salary
FROM Departments d inner join Employee e ON e.dno =d.Dnum
GROUP BY d.Dname

--5.	List the full name of all managers who have no dependents.
SELECT e.Fname + ' ' + e.Lname as 'FULL Name'
FROM employee e inner join departments d on d.MGRSSN=e.SSN 
WHERE MGRSSN not in (SELECT ESSN from dependent)

--6.	For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
SELECT d.Dname,d.Dnum,COUNT(e.SSN)
FROM Departments d inner join employee e on e.dno=d.Dnum
GROUP BY D.Dname ,d.Dnum
HAVING AVG(Salary) < (SELECT AVG(Salary) FROM Employee)

--7.	Retrieve a list of employees names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.
SELECT e.Fname + ' ' + e.Lname as 'Name',p.pname
FROM Employee e join Works_for w on w.ESSn=e.SSN inner join project p on p.Pnumber=w.Pno
ORDER BY e.Dno ,e.Lname,e.Fname

--8.	Try to get the max 2 salaries using subquery
SELECT MAX(Salary) AS Salary
FROM Employee

UNION 

SELECT MAX(Salary)
FROM Employee
WHERE Salary < (SELECT MAX(Salary) FROM Employee);

--9.	Get the full name of employees that is similar to any dependent name
SELECT Fname + ' ' + Lname AS Name
FROM Employee

INTERSECT

SELECT Dependent_name
FROM Dependent

--10.	Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
SELECT SSN, Fname + ' ' + Lname as 'Name'
FROM employee e
WHERE exists (SELECT ESSN FROM dependent d WHERE e.ssn=d.ESSN)

--11.	In the department table insert new department called "DEPT IT" , 
--with id 100, employee with SSN = 112233 as a manager for this department. 
--The start date for this manager is '1-11-2006'
INSERT INTO Departments 
VaLUES('DEPT IT',100,112233,'1-11-2006')

--12.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the 
--new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 

	--a.	First try to update her record in the department table
	--b.	Update your record to be department 20 manager.
	--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
UPDATE Departments
SET MGRSSN=968574,[MGRStart Date]=GETDATE()
WHERE Dnum=100

UPDATE Departments
SET MGRSSN=102672,[MGRStart Date]=GETDATE()
WHERE Dnum=20

UPDATE Employee 
SET Superssn=102672
WHERE SSN=102660

/*13.	Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344)
    so try to delete his data from your database in case you know that you will be temporarily in his position.
	Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any 
	employees or works in any projects and handle these cases).*/
DELETE FROM Dependent 
WHERE ESSN = 223344

UPDATE Departments
SET MGRSSN=102672,[MGRStart Date]=GETDATE()
WHERE MGRSSN=223344

UPDATE employee
SET Superssn=102672
WHERE Superssn=223344

UPDATE Works_for
SET ESSn=102672, Hours=0
WHERE ESSN=223344

DELETE FROM employee WHERE SSN=223344

--14.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
UPDATE Employee
SET salary=Salary*1.3
FROM Employee e join Works_for w on w.ESSn=e.SSN join project p on p.Pnumber=w.Pno AND Pname='Al Rabwah'

