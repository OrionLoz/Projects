CREATE PROCEDURE [dbo].[UserLeads_Insert]
    @Email nvarchar(255),
    @FirstName nvarchar(100),
    @LastName nvarchar(100),
    @LoanAmount decimal(15, 2),
    @LoanTypeId int,
    @Token nvarchar(50),
    @StatusId int,
    @Id int OUTPUT
AS
BEGIN
    INSERT INTO [dbo].[UserLeads]
    (
        [Email],
        [FirstName],
        [LastName],
        [LoanAmount],
        [LoanTypeId],
        [Token],
        [StatusId]
    )
    VALUES
    (
        @Email,
        @FirstName,
        @LastName,
        @LoanAmount,
        @LoanTypeId,
        @Token,
        @StatusId
    );

    SET @Id = SCOPE_IDENTITY();
END;
