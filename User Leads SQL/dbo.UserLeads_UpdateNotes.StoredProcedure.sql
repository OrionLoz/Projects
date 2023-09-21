CREATE proc [dbo].[UserLeads_UpdateNotes]
				@Id int,
				@Notes nvarchar(255)

as



BEGIN


UPDATE dbo.UserLeads

SET	[Notes] = @Notes,
	[DateModified] = GETUTCDATE()

WHERE [Id] = @Id


END
GO
