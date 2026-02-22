USE ITI
--1.	 Create a scalar function that takes date and returns Month name of that date.
CREATE FUNCTION MONTH_OF_DATE(@date date)
 RETURNS varchar(20)
 AS
	BEGIN 
	   RETURN FORMAT (@date,'MMMM');
	END;
    
SELECT dbo.MONTH_OF_DATE('2002-09-15') AS MONTH;

--2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
CREATE FUNCTION Values_Between(@x int,@y int)
  RETURNS @t table (Value int)
  AS
  BEGIN
  WHILE @x+1<@y
  BEGIN
   set @x+=1
   insert into @t values(@x)
  END
  RETURN
END;

select * from  dbo.Values_Between(20,30)

--3.	 Create inline function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION get_st_data (@st_no int)
RETURNS TABLE
AS
RETURN
(SELECT d.Dept_Name,isnull(s.St_Fname, '') + ' ' + isnull(s.St_Lname, '') AS FullName
    FROM Student s INNER JOIN Department d ON s.Dept_Id = d.Dept_Id
    where s.St_Id = @st_no
)

SELECT * FROM  dbo.get_st_data(10)

/*4.	Create a scalar function that takes Student ID and returns a message to user 
a.	If first name and Last name are null then display 'First name & last name are null'
b.	If First name is null then display 'first name is null'
c.	If Last name is null then display 'last name is null'
d.	Else display 'First name & last name are not null'*/
CREATE FUNCTION ST_MSG (@id int)
RETURNS varchar(50)
AS
BEGIN
    DECLARE @x varchar(20)
    DECLARE @y varchar(20)
    DECLARE @msg varchar(50)
    SELECT @x = st_Fname,@y =St_Lname
    FROM student
    WHERE st_id = @id;

    if @x IS NULL AND @y IS NULL
        SET @msg = 'First name & last name are null';
    else if @x IS NULL
        SET @msg = 'First name is null';
    else if @y IS NULL
        SET @msg = 'Last name is null';
    else 
        SET @msg = 'First name & last name are not null';

    RETURN @msg;
END

select dbo.ST_MSG(13)

--5.	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
CREATE FUNCTION manager_data(@mgr_id int )
RETURNS  table 
AS
RETURN ( SELECT dept_name,Ins_Name,manager_hiredate
FROM department d join instructor i ON i.Ins_Id=d.Dept_Manager
WHERE d.Dept_manager=@mgr_id)

SELECT * FROM dbo.manager_data(2)

/*6.	Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function*/

CREATE FUNCTION student_name(@string varchar(20))
RETURNS @t table(student_name varchar(30))
AS 
BEGIN
IF @string ='first name'
 INSERT INTO @t
  SELECT isnull(st_fname,'first_name')  from student
ELSE IF @string ='last name'
 INSERT INTO @t
  SELECT isnull(st_Lname,'Last_name')  from student
ELSE
INSERT INTO @t
  SELECT isnull(St_Fname,'') + ' ' +isnull(St_Lname,'') 
  from student
    
    RETURN
END

SELECT * FROM dbo.student_name('first name')
SELECT * FROM dbo.student_name('last name')
SELECT * FROM dbo.student_name('full name')

--7.	Write a query that returns the Student No and Student first name without the last char
SELECT st_id ,substring(st_fname,1,len(st_fname)-1)
from student

--8.	Wirte query to delete all grades for the students Located in SD Department 
UPDATE sc
SET sc.grade = NULL
FROM stud_course sc
JOIN student s ON s.st_id = sc.st_id
JOIN department d ON s.dept_id = d.dept_id
WHERE d.dept_name = 'SD'

--9.	Using Merge statement between the following two tables [User ID, Transaction Amount]
MERGE INTO LastTransaction as L
USING DailyTransaction as D
ON L.User_id=D.User_id

WHEN MATCHED THEN
 UPDATE 
 SET L.Transaction_Amount=D.Transaction_Amount
WHEN NOT MATCHED BY TARGET THEN
 INSERt (User_id, Transaction_Amount)
 VALUES(D.User_id, D.Transaction_Amount)
WHEN NOT MATCHED BY SOURCE THEN
DELETE;
 

--10.	Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB then allow him to select and insert data into tables and deny Delete and update






