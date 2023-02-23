use Database Demo

CREATE TABLE [Document] (  [DocumentId] int,  [UserId] int)

CREATE TABLE [DocType] (  [DocTypeId] int PRIMARY KEY IDENTITY(1, 1) not null,  [DocTypeName] varchar(32) not null)

CREATE TABLE [DocMimeType] (  [DocMimeTypeId] int PRIMARY KEY IDENTITY(1, 1) not null,  [DocMimeName] varchar(64) not null)

CREATE TABLE [Property] (  [PropertyId] int PRIMARY KEY IDENTITY(1, 1)not null,  [PropertyName] varchar(256)not null, [Address] varchar(256)not null,  
[city] varchar(24) not null,  [pincode] varchar(6)not null,  [Building] varchar(64)not null,  [FloorNumber] smallint not null,  [Flatnumber] smallint not null, 
[IsActive] bit not null)

CREATE TABLE [Users] (  [UserId] int PRIMARY KEY IDENTITY(1, 1)not null,  [FirstName] varchar(32)not null,  [LastName] varchar(32)not null,  
[Password] varchar(32)not null,  [Phonenumber] varchar(20) not null,  [EmailId] varchar(64)not null,  [IsActive] bit not null,  [roleId] int not null,  
[PropertyId] int not null)

CREATE TABLE [role] (  [roleId] int PRIMARY KEY IDENTITY(1, 1) not null,  [name] varchar(32) not null,  [IsActive] bit not null)

CREATE TABLE [DocumentDetails] (  [DocumentId] int PRIMARY KEY IDENTITY(1, 1) not null,  [DocumentName] varchar(32) not null,  [Location] varchar(256)not null,  
[IsVerified] bit not null,  [IsActive] bit not null,  [DocTypeId] int not null,  [DocMimeTypeId] int not null,  [CreateDate] Date not null,  
[ModifiedDate] Date not null)


ALTER TABLE [Document] ADD FOREIGN KEY ([DocumentId]) REFERENCES [DocumentDetails] ([DocumentId])

ALTER TABLE [Document] ADD FOREIGN KEY ([UserId]) REFERENCES [Users] ([UserId])

ALTER TABLE [Users] ADD FOREIGN KEY ([roleId]) REFERENCES [role] ([roleId])

ALTER TABLE [Users] ADD FOREIGN KEY ([PropertyId]) REFERENCES [Property] ([PropertyId])

ALTER TABLE [DocumentDetails] ADD FOREIGN KEY ([DocTypeId]) REFERENCES [DocType] ([DocTypeId])

ALTER TABLE [DocumentDetails] ADD FOREIGN KEY ([DocMimeTypeId]) REFERENCES [DocMimeType] ([DocMimeTypeId])



INSERT INTO DocType (DocTypeName)
VALUES ('Passport'), ('Driver License'), ('Voter ID'), ('Aadhaar Card'), ('PAN Card');

INSERT INTO DocType (DocTypeName)
values('Agreement')

INSERT INTO DocMimeType (DocMimeName)
VALUES ('PDF'), ('JPG'), ('PNG'), ('DOCX'), ('XLSX'), ('ZIP'), ('RAR');

INSERT INTO Property (PropertyName, Address , city, pincode, Building, FloorNumber, Flatnumber, IsActive)
VALUES ('Smartworks', 'kalyani nagar', 'Pune','411006', 'BBD', 7, 2, 1), 
       ('Marigold', 'pune','Pune', '411006', 'Tower B', 2, 30, 1),
	   ('Darshna park', 'kalyani nagar','Pune', '410051' ,'wing c',1,2,1) ,
	   ('Mars society' , 'Irani cafe','Pune', '410078', 'E3' , 3, 10, 1) 


INSERT INTO role (name, IsActive)
VALUES ('Admin', 1), ('User', 1),('PropertyOwner', 1);

INSERT INTO Users (FirstName, LastName, Password, Phonenumber, EmailId, IsActive, roleId, PropertyId)
VALUES ('Divya', 'wani', 'pabc123', '9373307580', 'divyaw@bbd.co.za', 1, 1, 3),
       ('Anuja', 'Nikumbh', 'a123@', '9373380920', 'anuja@bbd.co.za', 1, 2, 4)

INSERT INTO DocumentDetails (DocumentName, Location, IsVerified, IsActive, DocTypeId, DocMimeTypeId, CreateDate, ModifiedDate)
VALUES ('Passport', 'C:\Users\bbdnet10237\Desktop\Documents\Appointment receipt', 1, 1, 1, 2, '2023-02-01', '2023-03-01'),
       ('Aadhar card', 'C:\Users\bbdnet10237\Desktop\Documents\Aadhar.jpg', 1, 1, 1, 2, '2022-01-01', '2022-01-01')


select *from DocumentDetails


//Store Procedure

CREATE PROCEDURE GetUserDocuments
    @UserId int
AS
BEGIN

    SELECT d.DocumentId, d.DocumentName, d.Location, d.IsVerified, d.IsActive, dt.DocTypeName, dmt.DocMimeName, d.CreateDate, d.ModifiedDate
    FROM DocumentDetails d
    INNER JOIN DocType dt ON d.DocTypeId = dt.DocTypeId
    INNER JOIN DocMimeType dmt ON d.DocMimeTypeId = dmt.DocMimeTypeId
    INNER JOIN Document doc ON d.DocumentId = doc.DocumentId
    WHERE doc.UserId = @UserId;

END

Exec GetUserDocuments 3;



CREATE or alter  PROCEDURE GetActivePropertiesByCity
    @City varchar(24)
AS
BEGIN
    SELECT PropertyId, PropertyName, Address, city, pincode, Building, FloorNumber, Flatnumber, IsActive
    FROM Property
    WHERE city = @City AND IsActive = 1;

END
 exec GetActivePropertiesByCity pune


//View

CREATE VIEW [DocumentDetailsView]
AS
SELECT d.DocumentId, d.DocumentName, d.Location, d.IsVerified, d.IsActive, dt.DocTypeName, dmt.DocMimeName, d.CreateDate, d.ModifiedDate,
       u.FirstName, u.LastName, u.Phonenumber, u.EmailId, p.PropertyName, p.Address, p.city, p.pincode, p.Building, p.FloorNumber, p.Flatnumber, r.name AS roleName
FROM DocumentDetails d
INNER JOIN DocType dt ON d.DocTypeId = dt.DocTypeId
INNER JOIN DocMimeType dmt ON d.DocMimeTypeId = dmt.DocMimeTypeId
INNER JOIN Document doc ON d.DocumentId = doc.DocumentId
INNER JOIN Users u ON doc.UserId = u.UserId
INNER JOIN Property p ON u.PropertyId = p.PropertyId
INNER JOIN role r ON u.roleId = r.roleId;

select * from DocumentDetailsView


CREATE VIEW [ActiveUserView]
AS
SELECT u.UserId, u.FirstName, u.LastName, u.EmailId, p.PropertyName, p.Address, p.City, p.Pincode
FROM Users u
INNER JOIN Property p ON u.PropertyId = p.PropertyId
WHERE u.IsActive = 1;

select * from ActiveUserView


//User Defined Function 


CREATE FUNCTION dbo.CalculateArea
(
    @width INT,
    @height INT
)
RETURNS INT
AS
BEGIN
    DECLARE @area INT
    SET @area = @width * @height
    RETURN @area
END
SELECT dbo.CalculateArea(15,25) 
