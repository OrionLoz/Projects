USE [MoneFi]
GO
/****** Object:  StoredProcedure [dbo].[UserLeads_UpdateNotes]    Script Date: 8/9/2023 9:57:09 AM ******/
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

CREATE proc [dbo].[UserLeads_UpdateNotes]
								@Id int,
								@Notes nvarchar(255)

as

/*---Test Code---
SELECT *
FROM dbo.UserLeads

DECLARE @Id int = 3
		,@Notes nvarchar(255) = 'Lorem ipsum dolor sit ametconsectetur adipiscing elit'

EXECUTE dbo.UserLeads_UpdateNotes @Id 
								,@Notes


SELECT *
FROM dbo.UserLeads

*/

BEGIN


UPDATE dbo.UserLeads

SET		[Notes] = @Notes,
		[DateModified] = GETUTCDATE()

	WHERE [Id] = @Id


END
GO
