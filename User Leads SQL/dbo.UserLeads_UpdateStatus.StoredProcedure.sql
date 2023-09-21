CREATE PROCEDURE [dbo].[UserLeads_UpdateStatus]
    @Id int,
    @StatusId int
AS
BEGIN
    UPDATE dbo.UserLeads
    SET [StatusId] = @StatusId,
        [DateModified] = GETUTCDATE()
    WHERE [Id] = @Id;
END;
