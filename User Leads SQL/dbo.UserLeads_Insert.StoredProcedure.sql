USE [MoneFi]
GO
/****** Object:  StoredProcedure [dbo].[UserLeads_Insert]    Script Date: 8/9/2023 9:57:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Orion Lozano
-- Create date: 7/1/2023

-- Description:Inserts into dbo.UserLeads

-- Code Reviewer: Missael Macias

-- MODIFIED BY:
-- MODIFIED DATE: 
-- Code Reviewer:
-- Note : 
-- =============================================

	CREATE proc [dbo].[UserLeads_Insert]						
						@Email nvarchar(255)
						,@FirstName nvarchar(100)
						,@LastName nvarchar(100)
						,@LoanAmount decimal(15, 2)
						,@LoanTypeId int
						,@Token nvarchar(50)
						,@StatusId int
						,@Id int OUTPUT
							


as

/*---Test Code---
	Declare @Id int = 0;

	Declare @Email nvarchar(255) = 'test3@email.com'
					,@FirstName nvarchar(100) = 'Test3'
					,@LastName nvarchar(100) = 'Name3'
					,@LoanAmount decimal(15, 2) = 300.50
					,@LoanTypeId int = 3
					,@Token nvarchar(20) = 'Test Token3'
					,@StatusId int = 3
		

	Execute dbo.UserLeads_Insert
						@Email 
						,@FirstName 
						,@LastName 
						,@LoanAmount 
						,@LoanTypeId 
						,@Token
						,@StatusId 
						,@Id OUTPUT

	Select
		Email 
		,FirstName 
		,LastName 
		,LoanAmount 
		,LoanTypeId 
		,Token
		,StatusId 
		,Id 

	From dbo.UserLeads

	Select *
	From dbo.StatusTypes
	Select *
	From dbo.LoanTypes

*/

BEGIN

	INSERT INTO [dbo].[UserLeads]
					([Email]
					,[FirstName]
					,[LastName]
					,[LoanAmount]
					,[LoanTypeId]
					,[Token]
					,[StatusId])
	VALUES
		(@Email,
		@FirstName,
		@LastName,
		@LoanAmount,
		@LoanTypeId,
		@Token,
		@StatusId)

	SET @Id = SCOPE_IDENTITY();

END
GO
