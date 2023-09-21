
CREATE proc [dbo].[UserLeads_SelectAll]
			 @PageIndex int
			 ,@PageSize int

as


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
