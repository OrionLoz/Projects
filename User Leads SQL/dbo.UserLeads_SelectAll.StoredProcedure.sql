CREATE PROCEDURE [dbo].[UserLeads_SelectAll]
    @PageIndex int,
    @PageSize int
AS
BEGIN
    DECLARE @offset int = @PageIndex * @PageSize;

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
    INNER JOIN dbo.LoanTypes as lt
        ON ul.LoanTypeId = lt.Id
    INNER JOIN dbo.StatusTypes as st
        ON ul.StatusId = st.Id
    ORDER BY ul.Id
    OFFSET @offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
