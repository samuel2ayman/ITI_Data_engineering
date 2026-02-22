--1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
USE ITI
CREATE PROC st_num 
AS 
   SELECT d.dept_name,count(st_id)
   FROM department d join student s on s.dept_id=d.dept_id
   GROUP BY d.dept_name
st_num 
/*2.	Create a stored procedure that will check for the # of employees in the project p1 
if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” 
if they are less display a message to the user “'The following employees work for the project p1'” 
in addition to the first name and last name of each one. [Company DB] */
CREATE PROC employee_project @p varchar(30)
AS 
  IF (SELECT count(ESSN) from company.project p join works_for w on p.pnumber=w.pno 
      WHERE p.pname=@p)>=3
      SELECT 'The number of employees in the project '+ @p +' is 3 or more' as message
  ELSE 
    SELECT 'The following employees work for the project ' + @p as message
    UNION ALL
    SELECT IsNULL(Fname,'')+' '+IsNULL(Lname,'')
    from company.project p join works_for w on p.pnumber=w.pno join employee e on e.SSN=w.ESSn
    WHERE p.pname=@p

employee_project 'AL Solimaniah'

/*3.	Create a stored procedure that will be used in case there is an old employee has left 
the project and a new one become instead of him. The procedure should take 3 parameters 
(old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. 
[Company DB]*/
USE Company_SD

CREATE proc new_emp @oEmp_number int , @nEmp_number int , @pno int 
AS 
UPDATE Works_for
   SET ESSN = @nEmp_number ,hours=0
   WHERE ESSN =@oEmp_number and pno =@pno

new_emp 112233, 669955 ,100

/*4.	add column budget in project table and insert any draft values in it then 
then Create an Audit table with the following structure 

This table will be used to audit the update trials on the Budget column (Project table, Company DB)
Example:
If a user updated the budget column then the project number, user name that made that update, the date 
of the modification and the value of the old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column*/
ALTER TABLE company.project add budget int 

Create Table Audit1
(
	ProjectNo int not null ,
	UserName nvarchar(50) not null  ,
	ModifiedDate date  ,
	Budget_Old money ,
	Budget_New money 
)

CREATE Trigger budget
on company.project 
AFTER update 
AS 
   IF update(budget)
   BEGIN
   DECLARE @pno int , @old_budget int,@new_budget int
   SELECT @pno=pnumber,@new_budget=budget from inserted
   SELECT @old_budget=budget from deleted
   INSERT INTO Audit1
   VALUES(@pno,SUSER_NAME(),GETDATE(),@old_budget,@new_budget)
   END

update company.project set budget=50000
WHERE pnumber=100

select * from audit1

/*5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
“Print a message for user to tell him that he can’t insert a new record in that table”*/
USE ITI

CREATE TRIGGER no_insert
ON Department
instead of insert
AS
  SELECT 'you can’t insert a new record in Department table'

insert into department (dept_id,dept_name,dept_desc)
VALUES(50,'dept','finance')

--6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
USE Company_SD

alter TRIGGER no_insert2
ON Employee
instead of insert
AS
  IF format(GETDATE(),'MMMM') ='March'
    SELECT 'Not allowed to insert in March'
  ELSE
    INSERT INTO employee 
    SELECT * from inserted

insert into employee (Fname,Lname,SSN)
VALUES('Samuel','Ayman','885544')

/*7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name
, Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”*/
CREATE TABLE Audit(
Server_user varchar(50) not null ,
Mod_Date date,
Note varchar(300)
)

CREATE Trigger t3
ON student
after insert 
AS
INSERT into Audit
SELECT SUSER_NAME(),GETDATE(),concat(SUSER_NAME(),' Insert New Row with Key=', st_id ,'in table student') FROM inserted

insert into student (st_id,st_fname,st_lname)
VALUES(205456,'ali','karam')

select * from audit

/*8.	 Create a trigger on student table instead of delete to add Row in Student Audit table
(Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”*/

CREATE Trigger t4
ON student
INSTEAD OF DELETE 
AS
INSERT into Audit
SELECT SUSER_NAME(),GETDATE(),concat('try to delete Row with Key=',st_id ) from deleted

DELETE from student 
where st_id = 20546

select * from audit