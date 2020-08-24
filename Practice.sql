CREATE DATABASE MyBlog
USE MyBog
GO
CREATE TABLE Users(
UserID INT PRIMARY KEY IDENTITY(1,1),
UserName VARCHAR(20),
Password VARCHAR(30),
Email VARCHAR(30) UNIQUE,
Address NVARCHAR(200)
)
GO
CREATE TABLE Posts(
PostID INT PRIMARY KEY IDENTITY(1,1),
Title NVARCHAR(200),
Content NVARCHAR(max),
Tag NVARCHAR(100),
Status BIT,
CreateTime DATETIME CHECK (CreateTime = GETDATE()),
UpdateTime DATETIME,
UserID INT UNIQUE,
CONSTRAINT FK FOREIGN KEY (UserID) REFERENCES Users(UserID)
)
GO
CREATE TABLE Comments(
CommentID INT PRIMARY KEY IDENTITY,
Content NVARCHAR(500),
Status BIT,
CreateTime DATETIME,
Author NVARCHAR(30),
Email NVARCHAR(50) NOT NULL,
PostID INT,
CONSTRAINT FK_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID)
)
DROP TABLE Users
DROP TABLE Posts
DROP TABLE Comments
ALTER TABLE Comments
	ADD CONSTRAINT FK_Email CHECK(Email LIKE '%@%')
ALTER TABLE Users
	ADD CONSTRAINT PK_Email CHECK(Email LIKE '%@')
GO
CREATE UNIQUE INDEX IX_UserName ON Users(UserName)
GO
INSERT INTO Users VALUES
('David Beckham','0012011221','Davidhihi@gmail.com',N'Hà Nội,Việt Nam'),
('Taylor Swift','09012114','Taylor@gmail.com',N'Huế,Việt Nam'),
('Justin Beber','09849518','Justinlegue@gmail.com',N'Thanh Hóa,Việt Nam'),
('Leo Messi','036820271','Messiluis@gmail.com',N'Nghệ An,Việt Nam')
Go
INSERT INTO Posts VALUES
('ok ok','Once to be a gunner always to be  gunner','idnk','0',GETDATE(),NULL,1),
('ha ha','ok','blink','1',GETDATE(),NULL,2),
('hi hi hi','captain teemo and Buddy','asawffa','1',GETDATE(),NULL,3)
INSERT INTO Comments VALUES
('LOL',0,GETDATE(),'David Beckham','Davidhihi@gmail.com',1),
('LOL',1,GETDATE(),'Taylor Swift','Taylor@gmail.com',2),
('LOL',0,GETDATE(),'Justin Beber','Justinlegue@gmail.com',3)
GO
SELECT * FROM Users
SELECT * FROM Posts WHERE Tag = 'Social'
SELECT * FROM Comments
SELECT * FROM Users WHERE Email ='Justinlegue@gmail.com'
SELECT COUNT(*) AS COUNT FROM Comments
CREATE VIEW v_NewPost AS 
SELECT TOP 2 dbo.Posts.Title,dbo.Users.UserName,dbo.Comments.CreatTime FROM dbo.Posts
INNER JOIN dbo.Users ON dbo.Posts.UserID = dbo.Users.UserID
ORDER BY dbo.Posts.CreateTime DESC
GO
CREATE PROCEDURE sp_GetComment 
@PostsID INT AS 
BEGIN 
SELECT * FROM Comments WHERE PostsID = @PostsID
END
GO
CREATE TRIGGER tg_UpdateTime
ON Posts
AFTER  INSERT,UPDATE AS
BEGIN
   UPDATE Posts 
   SET UpdateTime = GETDATE()
   FROM Posts
   JOIN deleted ON Posts.PostID = deleted.PostID    
END