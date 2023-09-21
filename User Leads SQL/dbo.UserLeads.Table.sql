CREATE TABLE [dbo].[UserLeads](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Email] [nvarchar](255) NOT NULL,
    [FirstName] [nvarchar](100) NOT NULL,
    [LastName] [nvarchar](100) NOT NULL,
    [LoanAmount] [decimal](15, 2) NOT NULL,
    [LoanTypeId] [int] NOT NULL,
    [Token] [nvarchar](50) NOT NULL,
    [StatusId] [int] NOT NULL,
    [DateCreated] [datetime2](7) NOT NULL,
    [DateModified] [datetime2](7) NOT NULL,
    [Notes] [nvarchar](255) NULL,

    CONSTRAINT [PK_UserLeads] PRIMARY KEY CLUSTERED 
    (
        [Id] ASC
    )WITH (
        PAD_INDEX = OFF, 
        STATISTICS_NORECOMPUTE = OFF, 
        IGNORE_DUP_KEY = OFF, 
        ALLOW_ROW_LOCKS = ON, 
        ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]
);

-- Add default constraints for DateCreated and DateModified columns
ALTER TABLE [dbo].[UserLeads] ADD CONSTRAINT [DF_UserLeads_DateCreated] DEFAULT (getutcdate()) FOR [DateCreated];
ALTER TABLE [dbo].[UserLeads] ADD CONSTRAINT [DF_UserLeads_DateModified] DEFAULT (getutcdate()) FOR [DateModified];

-- Add foreign key constraint for LoanTypeId
ALTER TABLE [dbo].[UserLeads] WITH CHECK ADD CONSTRAINT [FK_UserLeads_LoanTypes] FOREIGN KEY([LoanTypeId])
REFERENCES [dbo].[LoanTypes] ([Id]);
ALTER TABLE [dbo].[UserLeads] CHECK CONSTRAINT [FK_UserLeads_LoanTypes];

-- Add foreign key constraint for StatusId
ALTER TABLE [dbo].[UserLeads] WITH CHECK ADD CONSTRAINT [FK_UserLeads_StatusTypes] FOREIGN KEY([StatusId])
REFERENCES [dbo].[StatusTypes] ([Id]);
ALTER TABLE [dbo].[UserLeads] CHECK CONSTRAINT [FK_UserLeads_StatusTypes];
