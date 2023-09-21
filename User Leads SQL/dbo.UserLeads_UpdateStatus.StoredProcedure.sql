USE [MoneFi]
GO
/****** Object:  StoredProcedure [dbo].[UserLeads_UpdateStatus]    Script Date: 8/9/2023 9:57:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: 
-- Create date: 

-- Description:

-- Code Reviewer:

-- MODIFIED BY:
-- MODIFIED DATE: 
-- Code Reviewer:
-- Note : 
-- =============================================

CREATE proc [dbo].[UserLeads_UpdateStatus]
								@Id int,
								@StatusId int

as

/*---Test Code---
SELECT *
FROM dbo.UserLeads

DECLARE @Id int = 1,
		@StatusId int = 1

EXECUTE dbo.UserLeads_UpdateStatus @Id 
								,@StatusId


SELECT *
FROM dbo.UserLeads

*/

BEGIN


UPDATE dbo.UserLeads
SET		[StatusId] = @StatusId,
		[DateModified] = GETUTCDATE()

	WHERE [Id] = @Id


END
GO
