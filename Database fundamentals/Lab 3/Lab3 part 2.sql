use LAB3

CREATE TABLE Instructor (
ID int	primary key identity,
F_name   varchar(20) ,
L_name   varchar(20) ,
BD       date,
Address  varchar(50) ,
Hire_date date Default GETDATE(),
Salary int Default 3000,
Over_Time int unique,
NetSalary AS (ISNULL(Salary,0) + ISNULL(Over_Time,0)),
Age AS (YEAR(GETDATE()) - YEAR(BD)),
Constraint C1085 CHECK(Address in ('Cairo','Alex')),
Constraint C1076 CHECK(Salary BETWEEN 1000 AND 5000),

)

CREATE TABLE Course (
CID int primary key identity,
C_name varchar(20) ,
Duration int unique
)


CREATE TABLE Lab (
LID int identity ,
Location varchar(20) ,
Capacity int ,
CID int ,
Constraint C1003 primary key(LID,CID),
Constraint C10200 foreign key(CID) references Course(CID)
  on delete cascade on update cascade,
Constraint C1011 CHECK(Capacity < 20 )
)

CREATE TABLE Teach(
I_ID int,
CID int ,
Constraint C10001 foreign key(CID) references Course(CID)
  on delete cascade on update cascade,
Constraint C10002 foreign key(I_ID) references Instructor(ID)
  on delete cascade on update cascade,
Constraint C10003 primary key(I_ID,CID)
)
