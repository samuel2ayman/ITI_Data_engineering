USE ITI

--1.  Create a view that displays student full name, course name if the student has a grade more than 50. 
USE ITI
CREATE VIEW stud_data
as 
  SELECT isnull(St_Fname,'') + ' ' +isnull(St_Lname,'') As 'full name',c.Crs_Name
  FROM student s join Stud_Course sc on s.st_id=sc.St_Id join course c ON c.Crs_Id=sc.Crs_Id
  WHERE sc.Grade > 50

  SELECT * from stud_data
--2.	 Create an Encrypted view that displays manager names and the topics they teach. 
USE ITI
ALTER VIEW mgr_data
WITH encryption
as 
  SELECT i.Ins_Name as ManagerName , Top_Name as Topic
  FROM department d join instructor i on d.Dept_Manager=i.Ins_Id
  join Ins_Course ic on i.Ins_Id=ic.Ins_Id 
  join course c on c.Crs_Id=ic.Crs_Id
  join topic t on t.Top_Id = c.Top_Id

SELECT * from mgr_data
--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
CREATE VIEW ins_data
as 
  SELECT i.ins_name,d.Dept_Name
  FROM instructor i join department d on d.Dept_Id=i.Dept_Id
  WHERE d.dept_name='SD' OR d.dept_name='Java'

SELECT * from ins_data
/*4.	 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
Note: Prevent the users to run the following query 
Update V1 set st_address=’tanta’
Where st_address=’alex’;*/
CREATE VIEW V1
AS
  SELECT * from student 
  WHERE st_address= 'alex' or st_address= 'cairo'
  WITH CHECK OPTION

SELECT * from V1

Update V1 set st_address='tanta'
Where st_address='alex';


--5.	Create a view that will display the project name and the number of employees work on it. “Use Company DB”
USE Company_SD

CREATE VIEW v2
AS
  SELECT pname , count(w.ESSn) AS EmpCount
  FROM project p join works_for w on p.Pnumber=w.Pno 
  GROUP BY Pname

SELECT * from v2

/*6.	Create the following schema and transfer the following tables to it 
a.	Company Schema 
i.	Department table (Programmatically)
ii.	Project table (by wizard)
b.	Human Resource Schema
i.	  Employee table (Programmatically)*/

CREATE SCHEMA company

ALTER SCHEMA company
TRANSFER dbo.departments

CREATE SCHEMA HR

ALTER SCHEMA HR
TRANSFER dbo.employee

--7.	Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. 
--What will happen?   Use ITI DB
USE ITI 
-- can't use clustered because the table have primary key and already one clustered index
Create clustered index  manager_Hiredate on Department(Manager_hiredate)

--8.	Create index that allow u to enter unique ages in student table. What will happen? Use ITI DBCreate unique index Unique_Age on Student(st_age) 
Create unique index Unique_Age on Student(st_age) 
--Fails if duplicate ages exist

/*9.	Create a cursor for Employee table that increases Employee salary by 10% if 
  Salary <3000 and increases it by 20% if Salary >=3000. Use company DB*/
USE Company_SD
DECLARE c1 CURSOR
FOR SELECT Salary FROM employee
FOR UPDATE
DECLARE @salary int   
OPEN c1
FETCH c1 INTO @salary

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @salary<3000
      UPDATE employee
      set salary = @salary *1.1
      WHERE current of c1
    ELSE if @salary>=3000
      UPDATE employee
      set salary = @salary *1.2
      WHERE current of c1

    FETCH c1 INTO @salary
END
CLOSE c1
DEALLOCATE c1

--10.	Display Department name with its manager name using cursor. Use ITI DB
Use ITI
DECLARE c2 CURSOR
FOR SELECT Dept_name,Ins_Name  FROM department d join instructor i ON i.Ins_Id=d.Dept_Manager
FOR read only
DECLARE @d_name varchar(30),@i_name varchar(30)
OPEN c2;
FETCH c2 INTO @d_name, @i_name

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @d_name as 'department_name', @i_name as 'manager_name' 
    FETCH c2 INTO @d_name, @i_name
END
CLOSE c2;
DEALLOCATE c2;

--11.	Try to display all instructor names in one cell separated by comma. Using Cursor . Use ITI DB
USE ITI
DECLARE c3 CURSOR
FOR SELECT ins_name FROM instructor
FOR read only
DECLARE @name varchar(30) , @names varchar (max)
OPEN c3;
FETCH c3 INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
    set @names= concat(@names,',',@name)
    FETCH c3 INTO @name
END
SELECT @names as 'all names'
CLOSE c3
DEALLOCATE c3
--12.	Try to generate script from DB ITI that describes all tables and views in this DB
--ERROR due to encrypted view
