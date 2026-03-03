USE [interviewflow]
GO
/****** Object:  Table [dbo].[tblActivityLogs]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblActivityLogs](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[iProjectId] [int] NULL,
	[iBoardId] [int] NULL,
	[iTaskId] [int] NULL,
	[iActorId] [int] NOT NULL,
	[sAction] [nvarchar](100) NOT NULL,
	[sEntityType] [nvarchar](50) NOT NULL,
	[iEntityId] [int] NOT NULL,
	[sMeta] [nvarchar](max) NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblAttachments]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAttachments](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iTaskId] [int] NOT NULL,
	[iUploadedBy] [int] NOT NULL,
	[sFileName] [nvarchar](500) NOT NULL,
	[nFileSize] [bigint] NOT NULL,
	[sMimeType] [nvarchar](255) NOT NULL,
	[sStorageKey] [nvarchar](1000) NOT NULL,
	[sThumbnailKey] [nvarchar](1000) NULL,
	[sUrl] [nvarchar](max) NOT NULL,
	[sThumbnailUrl] [nvarchar](max) NULL,
	[bIsProcessed] [bit] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBoardPresence]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBoardPresence](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iBoardId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[sSocketId] [nvarchar](255) NOT NULL,
	[sCursorPosition] [nvarchar](max) NULL,
	[dtLastSeenAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblBoards]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBoards](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iProjectId] [int] NOT NULL,
	[sName] [nvarchar](255) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[sType] [nvarchar](50) NULL,
	[nVersion] [int] NULL,
	[iCreatedBy] [int] NOT NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblChatChannels]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblChatChannels](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iProjectId] [int] NOT NULL,
	[sName] [nvarchar](100) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[bIsDefault] [bit] NULL,
	[iCreatedBy] [int] NOT NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblChatMessageReactions]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblChatMessageReactions](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iMessageId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[sEmoji] [nvarchar](10) NOT NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblChatMessages]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblChatMessages](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iChannelId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[sContent] [nvarchar](max) NOT NULL,
	[iParentMessageId] [int] NULL,
	[bIsEdited] [bit] NULL,
	[dtEditedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblChatReadReceipts]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblChatReadReceipts](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iChannelId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[iLastReadMessageId] [int] NOT NULL,
	[dtUpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblColumns]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblColumns](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iBoardId] [int] NOT NULL,
	[sName] [nvarchar](255) NOT NULL,
	[sColor] [nvarchar](7) NULL,
	[fPosition] [float] NOT NULL,
	[nTaskLimit] [int] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblCommentReactions]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCommentReactions](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iCommentId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[sEmoji] [nvarchar](10) NOT NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblComments]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblComments](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iTaskId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[iParentCommentId] [int] NULL,
	[sContent] [nvarchar](max) NOT NULL,
	[bIsEdited] [bit] NULL,
	[dtEditedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblJobLogs]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblJobLogs](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[sQueueName] [nvarchar](100) NOT NULL,
	[sJobId] [nvarchar](255) NOT NULL,
	[sJobType] [nvarchar](100) NOT NULL,
	[sPayload] [nvarchar](max) NULL,
	[sStatus] [nvarchar](50) NOT NULL,
	[nAttempts] [int] NULL,
	[sErrorMessage] [nvarchar](max) NULL,
	[dtStartedAt] [datetime] NULL,
	[dtCompletedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblLabels]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLabels](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iProjectId] [int] NOT NULL,
	[sName] [nvarchar](100) NOT NULL,
	[sColor] [nvarchar](7) NOT NULL,
	[iCreatedBy] [int] NOT NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblModules]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblModules](
	[iModuleId] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](255) NULL,
	[sDescription] [nvarchar](max) NULL,
	[dtCreatedAt] [datetime2](7) NULL,
	[dtUpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[iModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNotificationPreferences]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNotificationPreferences](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iUserId] [int] NOT NULL,
	[bTaskAssigned] [bit] NULL,
	[bTaskComment] [bit] NULL,
	[bTaskDueSoon] [bit] NULL,
	[bTaskCompleted] [bit] NULL,
	[bMentioned] [bit] NULL,
	[bProjectUpdates] [bit] NULL,
	[sDigestFrequency] [nvarchar](50) NULL,
	[dtUpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[iUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblNotifications]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNotifications](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iRecipientId] [int] NOT NULL,
	[iActorId] [int] NOT NULL,
	[sType] [nvarchar](100) NOT NULL,
	[sTitle] [nvarchar](500) NOT NULL,
	[sBody] [nvarchar](max) NULL,
	[sLink] [nvarchar](max) NULL,
	[iTaskId] [int] NULL,
	[iProjectId] [int] NULL,
	[bIsRead] [bit] NULL,
	[dtReadAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPermissions]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPermissions](
	[iPermissionId] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](255) NULL,
	[dtCreatedAt] [datetime2](7) NULL,
	[dtUpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[iPermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjectMembers]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjectMembers](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iProjectId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[iRoleId] [int] NOT NULL,
	[dtAddedAt] [datetime] NULL,
	[iAddedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProjects]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProjects](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[sName] [nvarchar](255) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[sIcon] [nvarchar](10) NULL,
	[sColor] [nvarchar](7) NULL,
	[sStatus] [nvarchar](50) NULL,
	[sVisibility] [nvarchar](50) NULL,
	[iCreatedBy] [int] NOT NULL,
	[dtStartDate] [datetime] NULL,
	[dtEndDate] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRefreshTokens]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRefreshTokens](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iUserId] [int] NOT NULL,
	[sTokenHash] [nvarchar](255) NOT NULL,
	[sDeviceInfo] [nvarchar](max) NULL,
	[sIpAddress] [nvarchar](45) NULL,
	[dtExpiresAt] [datetime] NOT NULL,
	[dtRevokedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[sTokenHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRoleChangeLogs]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRoleChangeLogs](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[iTargetUserId] [int] NOT NULL,
	[iChangedBy] [int] NOT NULL,
	[sScope] [varchar](50) NOT NULL,
	[iScopeId] [int] NOT NULL,
	[iOldRoleId] [int] NULL,
	[iNewRoleId] [int] NOT NULL,
	[sReason] [varchar](500) NULL,
	[dtCreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRolePermissions]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRolePermissions](
	[iRolePermissionId] [int] IDENTITY(1,1) NOT NULL,
	[iPermissionId] [int] NULL,
	[iModuleId] [int] NULL,
	[iRoleId] [int] NULL,
	[dtCreatedAt] [datetime2](7) NULL,
	[dtUpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[iRolePermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblRoles]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRoles](
	[iRoleId] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](255) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[bIsActive] [bit] NULL,
	[dtCreatedAt] [datetime2](7) NULL,
	[dtUpdatedAt] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[iRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[sName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblSearchIndex]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSearchIndex](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[sEntityType] [nvarchar](50) NOT NULL,
	[iEntityId] [int] NOT NULL,
	[sContent] [nvarchar](max) NOT NULL,
	[dtUpdatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTaskAssignees]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskAssignees](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iTaskId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[iAssignedBy] [int] NOT NULL,
	[dtAssignedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTaskLabels]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskLabels](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iTaskId] [int] NOT NULL,
	[iLabelId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTasks]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTasks](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iColumnId] [int] NOT NULL,
	[iBoardId] [int] NOT NULL,
	[iProjectId] [int] NOT NULL,
	[sTitle] [nvarchar](500) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[sType] [nvarchar](50) NULL,
	[sPriority] [nvarchar](50) NULL,
	[sStatus] [nvarchar](50) NULL,
	[fPosition] [float] NOT NULL,
	[iParentTaskId] [int] NULL,
	[iCreatedBy] [int] NOT NULL,
	[dtDueDate] [datetime] NULL,
	[dtStartDate] [datetime] NULL,
	[fEstimatedHours] [float] NULL,
	[fActualHours] [float] NULL,
	[nStoryPoints] [int] NULL,
	[nVersion] [int] NULL,
	[dtCompletedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtUpdatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTaskWatchers]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskWatchers](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iTaskId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUsers](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[sEmail] [nvarchar](255) NOT NULL,
	[sPasswordHash] [nvarchar](255) NULL,
	[sFullName] [nvarchar](255) NOT NULL,
	[sAvatarUrl] [nvarchar](max) NULL,
	[bIsEmailVerified] [bit] NULL,
	[dtLastActiveAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
	[iRoleId] [int] NULL,
	[bIsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[sEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWorkspaceInvitations]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWorkspaceInvitations](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[iInvitedBy] [int] NOT NULL,
	[sEmail] [nvarchar](255) NOT NULL,
	[sRole] [nvarchar](50) NOT NULL,
	[sTokenHash] [nvarchar](255) NOT NULL,
	[dtExpiresAt] [datetime] NOT NULL,
	[dtAcceptedAt] [datetime] NULL,
	[dtCreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[sTokenHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWorkspaceMembers]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWorkspaceMembers](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[iWorkspaceId] [int] NOT NULL,
	[iUserId] [int] NOT NULL,
	[sRole] [nvarchar](50) NOT NULL,
	[dtJoinedAt] [datetime] NULL,
	[iInvitedBy] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblWorkspaces]    Script Date: 03-03-2026 15:06:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWorkspaces](
	[iId] [int] IDENTITY(1,1) NOT NULL,
	[sName] [nvarchar](255) NOT NULL,
	[sSlug] [nvarchar](100) NOT NULL,
	[sDescription] [nvarchar](max) NULL,
	[sLogoUrl] [nvarchar](max) NULL,
	[iOwnerId] [int] NOT NULL,
	[iRoleId] [int] NOT NULL,
	[sPlan] [nvarchar](50) NULL,
	[nMaxMembers] [int] NULL,
	[dtCreatedAt] [datetime] NULL,
	[dtDeletedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[iId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[sSlug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblActivityLogs] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblAttachments] ADD  DEFAULT ((0)) FOR [bIsProcessed]
GO
ALTER TABLE [dbo].[tblAttachments] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblBoardPresence] ADD  DEFAULT (getdate()) FOR [dtLastSeenAt]
GO
ALTER TABLE [dbo].[tblBoards] ADD  DEFAULT ('kanban') FOR [sType]
GO
ALTER TABLE [dbo].[tblBoards] ADD  DEFAULT ((1)) FOR [nVersion]
GO
ALTER TABLE [dbo].[tblBoards] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblChatChannels] ADD  DEFAULT ((0)) FOR [bIsDefault]
GO
ALTER TABLE [dbo].[tblChatChannels] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblChatMessageReactions] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblChatMessages] ADD  DEFAULT ((0)) FOR [bIsEdited]
GO
ALTER TABLE [dbo].[tblChatMessages] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblChatReadReceipts] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblColumns] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblCommentReactions] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblComments] ADD  DEFAULT ((0)) FOR [bIsEdited]
GO
ALTER TABLE [dbo].[tblComments] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblJobLogs] ADD  DEFAULT ('pending') FOR [sStatus]
GO
ALTER TABLE [dbo].[tblJobLogs] ADD  DEFAULT ((0)) FOR [nAttempts]
GO
ALTER TABLE [dbo].[tblJobLogs] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblLabels] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblModules] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblModules] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((1)) FOR [bTaskAssigned]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((1)) FOR [bTaskComment]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((1)) FOR [bTaskDueSoon]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((0)) FOR [bTaskCompleted]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((1)) FOR [bMentioned]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ((1)) FOR [bProjectUpdates]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT ('daily') FOR [sDigestFrequency]
GO
ALTER TABLE [dbo].[tblNotificationPreferences] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblNotifications] ADD  DEFAULT ((0)) FOR [bIsRead]
GO
ALTER TABLE [dbo].[tblNotifications] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblPermissions] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblPermissions] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblProjectMembers] ADD  DEFAULT (getdate()) FOR [dtAddedAt]
GO
ALTER TABLE [dbo].[tblProjects] ADD  DEFAULT ('active') FOR [sStatus]
GO
ALTER TABLE [dbo].[tblProjects] ADD  DEFAULT ('workspace') FOR [sVisibility]
GO
ALTER TABLE [dbo].[tblProjects] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblRefreshTokens] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblRolePermissions] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblRolePermissions] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblRoles] ADD  DEFAULT ((1)) FOR [bIsActive]
GO
ALTER TABLE [dbo].[tblRoles] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblRoles] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblSearchIndex] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblTaskAssignees] ADD  DEFAULT (getdate()) FOR [dtAssignedAt]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ('task') FOR [sType]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ('medium') FOR [sPriority]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ('todo') FOR [sStatus]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT ((1)) FOR [nVersion]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblTasks] ADD  DEFAULT (getdate()) FOR [dtUpdatedAt]
GO
ALTER TABLE [dbo].[tblTaskWatchers] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblUsers] ADD  DEFAULT ((0)) FOR [bIsEmailVerified]
GO
ALTER TABLE [dbo].[tblUsers] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblUsers] ADD  DEFAULT ((1)) FOR [bIsActive]
GO
ALTER TABLE [dbo].[tblWorkspaceInvitations] ADD  DEFAULT ('member') FOR [sRole]
GO
ALTER TABLE [dbo].[tblWorkspaceInvitations] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblWorkspaceMembers] ADD  DEFAULT ('member') FOR [sRole]
GO
ALTER TABLE [dbo].[tblWorkspaceMembers] ADD  DEFAULT (getdate()) FOR [dtJoinedAt]
GO
ALTER TABLE [dbo].[tblWorkspaces] ADD  DEFAULT ('free') FOR [sPlan]
GO
ALTER TABLE [dbo].[tblWorkspaces] ADD  DEFAULT ((5)) FOR [nMaxMembers]
GO
ALTER TABLE [dbo].[tblWorkspaces] ADD  DEFAULT (getdate()) FOR [dtCreatedAt]
GO
ALTER TABLE [dbo].[tblActivityLogs]  WITH CHECK ADD FOREIGN KEY([iActorId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblActivityLogs]  WITH CHECK ADD FOREIGN KEY([iBoardId])
REFERENCES [dbo].[tblBoards] ([iId])
GO
ALTER TABLE [dbo].[tblActivityLogs]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblActivityLogs]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblActivityLogs]  WITH CHECK ADD FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblAttachments]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblAttachments]  WITH CHECK ADD FOREIGN KEY([iUploadedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblBoardPresence]  WITH CHECK ADD FOREIGN KEY([iBoardId])
REFERENCES [dbo].[tblBoards] ([iId])
GO
ALTER TABLE [dbo].[tblBoardPresence]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblBoards]  WITH CHECK ADD FOREIGN KEY([iCreatedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblBoards]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblChatChannels]  WITH CHECK ADD FOREIGN KEY([iCreatedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblChatChannels]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblChatMessageReactions]  WITH CHECK ADD FOREIGN KEY([iMessageId])
REFERENCES [dbo].[tblChatMessages] ([iId])
GO
ALTER TABLE [dbo].[tblChatMessageReactions]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblChatMessages]  WITH CHECK ADD FOREIGN KEY([iChannelId])
REFERENCES [dbo].[tblChatChannels] ([iId])
GO
ALTER TABLE [dbo].[tblChatMessages]  WITH CHECK ADD FOREIGN KEY([iParentMessageId])
REFERENCES [dbo].[tblChatMessages] ([iId])
GO
ALTER TABLE [dbo].[tblChatMessages]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblChatReadReceipts]  WITH CHECK ADD FOREIGN KEY([iChannelId])
REFERENCES [dbo].[tblChatChannels] ([iId])
GO
ALTER TABLE [dbo].[tblChatReadReceipts]  WITH CHECK ADD FOREIGN KEY([iLastReadMessageId])
REFERENCES [dbo].[tblChatMessages] ([iId])
GO
ALTER TABLE [dbo].[tblChatReadReceipts]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblColumns]  WITH CHECK ADD FOREIGN KEY([iBoardId])
REFERENCES [dbo].[tblBoards] ([iId])
GO
ALTER TABLE [dbo].[tblCommentReactions]  WITH CHECK ADD FOREIGN KEY([iCommentId])
REFERENCES [dbo].[tblComments] ([iId])
GO
ALTER TABLE [dbo].[tblCommentReactions]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblComments]  WITH CHECK ADD FOREIGN KEY([iParentCommentId])
REFERENCES [dbo].[tblComments] ([iId])
GO
ALTER TABLE [dbo].[tblComments]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblComments]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblLabels]  WITH CHECK ADD FOREIGN KEY([iCreatedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblLabels]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblNotificationPreferences]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblNotifications]  WITH CHECK ADD FOREIGN KEY([iActorId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblNotifications]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblNotifications]  WITH CHECK ADD FOREIGN KEY([iRecipientId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblNotifications]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblProjectMembers]  WITH CHECK ADD FOREIGN KEY([iAddedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblProjectMembers]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblProjectMembers]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblProjectMembers]  WITH CHECK ADD  CONSTRAINT [FK_tblProjectMembers_iRoleId] FOREIGN KEY([iRoleId])
REFERENCES [dbo].[tblRoles] ([iRoleId])
GO
ALTER TABLE [dbo].[tblProjectMembers] CHECK CONSTRAINT [FK_tblProjectMembers_iRoleId]
GO
ALTER TABLE [dbo].[tblProjects]  WITH CHECK ADD FOREIGN KEY([iCreatedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblProjects]  WITH CHECK ADD FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblRefreshTokens]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_tblRoleChangeLogs_ChangedBy] FOREIGN KEY([iChangedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] CHECK CONSTRAINT [FK_tblRoleChangeLogs_ChangedBy]
GO
ALTER TABLE [dbo].[tblRoleChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_tblRoleChangeLogs_NewRole] FOREIGN KEY([iNewRoleId])
REFERENCES [dbo].[tblRoles] ([iRoleId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] CHECK CONSTRAINT [FK_tblRoleChangeLogs_NewRole]
GO
ALTER TABLE [dbo].[tblRoleChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_tblRoleChangeLogs_OldRole] FOREIGN KEY([iOldRoleId])
REFERENCES [dbo].[tblRoles] ([iRoleId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] CHECK CONSTRAINT [FK_tblRoleChangeLogs_OldRole]
GO
ALTER TABLE [dbo].[tblRoleChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_tblRoleChangeLogs_TargetUser] FOREIGN KEY([iTargetUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] CHECK CONSTRAINT [FK_tblRoleChangeLogs_TargetUser]
GO
ALTER TABLE [dbo].[tblRoleChangeLogs]  WITH CHECK ADD  CONSTRAINT [FK_tblRoleChangeLogs_Workspace] FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblRoleChangeLogs] CHECK CONSTRAINT [FK_tblRoleChangeLogs_Workspace]
GO
ALTER TABLE [dbo].[tblSearchIndex]  WITH CHECK ADD FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblTaskAssignees]  WITH CHECK ADD FOREIGN KEY([iAssignedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblTaskAssignees]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblTaskAssignees]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblTaskLabels]  WITH CHECK ADD FOREIGN KEY([iLabelId])
REFERENCES [dbo].[tblLabels] ([iId])
GO
ALTER TABLE [dbo].[tblTaskLabels]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD FOREIGN KEY([iBoardId])
REFERENCES [dbo].[tblBoards] ([iId])
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD FOREIGN KEY([iColumnId])
REFERENCES [dbo].[tblColumns] ([iId])
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD FOREIGN KEY([iCreatedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD FOREIGN KEY([iParentTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblTasks]  WITH CHECK ADD FOREIGN KEY([iProjectId])
REFERENCES [dbo].[tblProjects] ([iId])
GO
ALTER TABLE [dbo].[tblTaskWatchers]  WITH CHECK ADD FOREIGN KEY([iTaskId])
REFERENCES [dbo].[tblTasks] ([iId])
GO
ALTER TABLE [dbo].[tblTaskWatchers]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblUsers]  WITH CHECK ADD  CONSTRAINT [FK_tblUsers_tblRoles_iRoleId] FOREIGN KEY([iRoleId])
REFERENCES [dbo].[tblRoles] ([iRoleId])
GO
ALTER TABLE [dbo].[tblUsers] CHECK CONSTRAINT [FK_tblUsers_tblRoles_iRoleId]
GO
ALTER TABLE [dbo].[tblWorkspaceInvitations]  WITH CHECK ADD FOREIGN KEY([iInvitedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaceInvitations]  WITH CHECK ADD FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaceMembers]  WITH CHECK ADD FOREIGN KEY([iInvitedBy])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaceMembers]  WITH CHECK ADD FOREIGN KEY([iUserId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaceMembers]  WITH CHECK ADD FOREIGN KEY([iWorkspaceId])
REFERENCES [dbo].[tblWorkspaces] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaces]  WITH CHECK ADD FOREIGN KEY([iOwnerId])
REFERENCES [dbo].[tblUsers] ([iId])
GO
ALTER TABLE [dbo].[tblWorkspaces]  WITH CHECK ADD  CONSTRAINT [FK_tblWorkspaces_iRoleId] FOREIGN KEY([iRoleId])
REFERENCES [dbo].[tblRoles] ([iRoleId])
GO
ALTER TABLE [dbo].[tblWorkspaces] CHECK CONSTRAINT [FK_tblWorkspaces_iRoleId]
GO
