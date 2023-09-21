USE [MoneFi]
GO
/****** Object:  StoredProcedure [dbo].[UserLeads_SelectAll]    Script Date: 8/9/2023 9:57:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Orion Lozano
-- Create date: 7/1/2023

-- Description: Selects all except token from dbo.UserLeads

-- Code Reviewer: Missael Macias

-- MODIFIED BY:
-- MODIFIED DATE: 
-- Code Reviewer:
-- Note : 
-- =============================================

CREATE proc [dbo].[UserLeads_SelectAll]
								@PageIndex int
								,@PageSize int

as

/*---Test Code---
Declare @PageIndex int = 0
		,@PageSize int = 5

Execute dbo.UserLeads_SelectAll
							@PageIndex
							,@PageSize

Select *
From dbo.UserLeads


*/

BEGIN

	DECLARE @offset int = @PageIndex * @PageSize
	
		SELECT ul.[Id]
			  ,ul.[Email]
			  ,ul.[FirstName]
			  ,ul.[LastName]			  
			  ,ul.[LoanAmount]			  
			  ,ul.[LoanTypeId] 
			  ,lt.Name as LoanTypeName 
			  ,ul.[StatusId]
			  ,st.Name as StatusTypeName
			  ,lt.Description
			  ,ul.[DateCreated]
			  ,ul.[DateModified]
			  ,ul.Notes
			  ,TotalCount = COUNT(1) OVER()

		FROM [dbo].[UserLeads] as ul 
		inner join dbo.LoanTypes as lt 
		on ul.LoanTypeId=lt.Id
		inner join dbo.StatusTypes as st 
		on ul.StatusId = st.Id

		ORDER BY ul.Id

		OFFSET @offset Rows
		Fetch Next @PageSize Rows ONLY

END
GO
