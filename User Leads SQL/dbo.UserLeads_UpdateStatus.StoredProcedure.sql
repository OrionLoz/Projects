CREATE proc [dbo].[UserLeads_UpdateStatus]
				@Id int,
				@StatusId int

as

BEGIN


UPDATE dbo.UserLeads
SET    [StatusId] = @StatusId,
       [DateModified] = GETUTCDATE()

WHERE [Id] = @Id


END
