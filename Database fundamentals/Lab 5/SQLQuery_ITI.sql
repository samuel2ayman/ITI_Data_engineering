USE ITI

--1.	Retrieve number of students who have a value in their age. 
SELECT COUNT(St_Age)
from Student

--2.	Get all instructors Names without repetition
SELECT DISTINCT ins_name
FROM instructor
/*3.	Display student with the following Format (use isNull function)
Student ID	Student Full Name	Department name*/
SELECT st_id as 'Student ID', ISNULL(st_fname,'-') + ' ' + ISNULL(st_lname,'-') as 'Student Full Name' ,Dept_name
FROM student s inner join Department d on d.Dept_Id=s.Dept_Id

/*4.	Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not*/
SELECT ins_name, Dept_name
FROM instructor i LEFT join Department d on d.Dept_Id=i.Dept_Id

/*5.	Display student full name and the name of the course he is taking
For only courses which have a grade  */
SELECT st_fname+' '+st_lname, crs_name
FROM Course c join Stud_Course sc on sc.Crs_Id=c.Crs_Id join student s on s.St_Id=sc.St_Id
WHERE sc.Grade is not null

--6.	Display number of courses for each topic name
SELECT top_name,count(crs_id) as 'number of courses'
FROM Topic T join course c on T.Top_Id=c.Top_Id
GROUP BY Top_Name

--7.	Display max and min salary for instructors
SELECT MAX(Salary) as 'MAX salary',MIN(Salary) as 'Min salary'
FROM instructor

--8.	Display instructors who have salaries less than the average salary of all instructors.
SELECT ins_name 
FROM instructor
WHERE Salary < (SELECT avg(Salary) FROM instructor )

--9.	Display the Department name that contains the instructor who receives the minimum salary.
SELECT Dept_name 
FROM Department d join Instructor i on i.Dept_Id=d.Dept_Id
WHERE i.Salary=(SELECT MIN(Salary) FROM Instructor)

--10.	 Select max two salaries in instructor table. 
SELECT top 2 Salary
FROM instructor
ORDER BY salary DESC

--11.	 Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT ins_name ,COALESCE(CONVERT(VARCHAR(20), salary), 'instructor bonus')
FROM instructor

--12.	Select Average Salary for instructors 
SELECT AVG(Salary)
FROM Instructor

--13.	Select Student first name and the data of his supervisor 
SELECT a.st_fname, b.*
FROM student a JOIN student b ON b.St_Id = a.St_super;
/*14.	Write a query to select the highest two salaries in Each Department 
for instructors who have salaries. “using one of Ranking Functions”*/
SELECT * 
FROM (select * , Dense_rank() OVER(partition by Dept_id ORDER BY Salary desc) as s
      FROM Instructor
      WHERE salary is not null
      ) as new_table
WHERE s <= 2

--15.	 Write a query to select a random  student from each department.  “using one of Ranking Functions”
SELECT * 
FROM (select * , ROW_NUMBER() OVER(partition by Dept_id ORDER BY NEWID() ) as s
      FROM Student) as new_table
WHERE s = 1
