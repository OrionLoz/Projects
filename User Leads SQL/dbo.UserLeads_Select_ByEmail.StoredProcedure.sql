USE [MoneFi]
GO
/****** Object:  StoredProcedure [dbo].[UserLeads_Select_ByEmail]    Script Date: 8/9/2023 9:57:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Orion Lozano
-- Create date: 7/1/2023

-- Description: Selects from dbo.UserLeads by email 

-- Code Reviewer: Missael Macias

-- MODIFIED BY:
-- MODIFIED DATE: 
-- Code Reviewer:
-- Note : 
-- =============================================

CREATE proc [dbo].[UserLeads_Select_ByEmail]
								@Email nvarchar(100)

as

/*---Test Code---	
	DECLARE @Email nvarchar(100) = 'test@email.com';
	EXECUTE dbo.UserLeads_Select_ByEmail @Email;

	Select *
	From dbo.StatusTypes
*/

BEGIN

	SELECT ul.[Id]
		  ,ul.[Email]
		  ,ul.[FirstName]
		  ,ul.[LastName]
		  ,ul.[LoanAmount]
		  ,ul.[LoanTypeId]
		  ,lt.[Name]
		  ,ul.[StatusId]
		  ,st.[Name]
		  ,lt.[Description]		  
		  ,ul.[DateCreated]
		  ,ul.[DateModified]
	  FROM [dbo].[UserLeads] as ul 
	  inner join [dbo].[StatusTypes] as st
	  on ul.StatusId = st.Id inner join
	  [dbo].[LoanTypes] as lt 
	  on ul.LoanTypeId = lt.Id

  WHERE Email = @Email

END
GO
