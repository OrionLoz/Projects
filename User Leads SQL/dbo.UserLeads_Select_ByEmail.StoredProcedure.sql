CREATE PROCEDURE [dbo].[UserLeads_Select_ByEmail]
    @Email nvarchar(100)
AS
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
    INNER JOIN [dbo].[StatusTypes] as st
        ON ul.StatusId = st.Id
    INNER JOIN [dbo].[LoanTypes] as lt
        ON ul.LoanTypeId = lt.Id
    WHERE Email = @Email;
END;

