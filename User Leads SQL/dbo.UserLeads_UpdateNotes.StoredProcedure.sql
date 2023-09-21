CREATE PROCEDURE [dbo].[UserLeads_UpdateNotes]
    @Id int,
    @Notes nvarchar(255)
AS
BEGIN
    UPDATE dbo.UserLeads
    SET [Notes] = @Notes,
        [DateModified] = GETUTCDATE()
    WHERE [Id] = @Id;
END;
