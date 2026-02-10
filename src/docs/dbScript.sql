-- ====================================================================
-- AUTOMATED INTERVIEW SCHEDULING PLATFORM - MSSQL DATABASE SCHEMA
-- ====================================================================
-- Standardized Naming Convention:
-- Tables: tbl prefix (e.g., tblUsers)
-- Fields: Data type prefix (i=INT, s=NVARCHAR, b=BIT, dt=DATETIME2, etc.)
-- ====================================================================

-- ====================================================================
-- CORE USER MANAGEMENT
-- ====================================================================

CREATE TABLE tblRoles (
    iRoleId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255) UNIQUE NOT NULL,
    sDescription NVARCHAR(MAX),
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_roles_name ON tblRoles(sName);

CREATE TABLE tblUsers (
    iUserId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255),
    sEmail NVARCHAR(255) UNIQUE NOT NULL,
    sPasswordHash NVARCHAR(255) NOT NULL,
    iRoleId INT NOT NULL,
    sTimezone NVARCHAR(100),
    sPhone NVARCHAR(50),
    bIsActive BIT DEFAULT 1,
    dtLastLogin DATETIME2,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_users_role FOREIGN KEY (iRoleId) REFERENCES tblRoles(iRoleId)
);
CREATE INDEX idx_users_email ON tblUsers(sEmail);
CREATE INDEX idx_users_role_id ON tblUsers(iRoleId);
CREATE INDEX idx_users_is_active ON tblUsers(bIsActive);

CREATE TABLE tblModules (
    iModuleId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255),
    sDescription NVARCHAR(MAX),
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE tblPermissions (
    iPermissionId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255),
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE tblRolePermissions (
    iRolePermissionId INT IDENTITY(1,1) PRIMARY KEY,
    iPermissionId INT,
    iModuleId INT,
    iRoleId INT,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (iPermissionId) REFERENCES tblPermissions(iPermissionId),
    CONSTRAINT fk_role_permissions_module FOREIGN KEY (iModuleId) REFERENCES tblModules(iModuleId),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (iRoleId) REFERENCES tblRoles(iRoleId)
);

CREATE TABLE tblUserPreferences (
    iUserPreferenceId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT UNIQUE NOT NULL,
    bEmailNotifications BIT DEFAULT 1,
    sReminderFrequency NVARCHAR(50) DEFAULT '24h',
    bCalendarSyncEnabled BIT DEFAULT 0,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_user_preferences_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_user_preferences_user_id ON tblUserPreferences(iUserId);

-- ====================================================================
-- JOB MANAGEMENT
-- ====================================================================

CREATE TABLE tblJobs (
    iJobId INT IDENTITY(1,1) PRIMARY KEY,
    sTitle NVARCHAR(255) NOT NULL,
    sDepartment NVARCHAR(255),
    sDescription NVARCHAR(MAX),
    sLocation NVARCHAR(255),  -- remote, office, hybrid
    iCreatedBy INT NOT NULL,
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    dtClosedAt DATETIME2,
    CONSTRAINT fk_jobs_created_by FOREIGN KEY (iCreatedBy) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_jobs_created_by ON tblJobs(iCreatedBy);

CREATE TABLE tblJobInterviewers (
    iJobInterviewerId INT IDENTITY(1,1) PRIMARY KEY,
    iJobId INT NOT NULL,
    iInterviewerId INT NOT NULL,
    dtAssignedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_job_interviewers_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId),
    CONSTRAINT fk_job_interviewers_interviewer FOREIGN KEY (iInterviewerId) REFERENCES tblUsers(iUserId),
    CONSTRAINT uq_job_interviewers UNIQUE (iJobId, iInterviewerId)
);
CREATE INDEX idx_job_interviewers_job_id ON tblJobInterviewers(iJobId);
CREATE INDEX idx_job_interviewers_interviewer_id ON tblJobInterviewers(iInterviewerId);

-- ====================================================================
-- CANDIDATE MANAGEMENT
-- ====================================================================

CREATE TABLE tblCandidates (
    iCandidateId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    iJobId INT NOT NULL,
    sCurrentStage NVARCHAR(50) DEFAULT 'applied',  -- applied, screening, scheduled, completed, rejected
    sResumeUrl NVARCHAR(MAX),
    sNotes NVARCHAR(MAX),
    sRejectionReason NVARCHAR(MAX),
    dtAppliedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_candidates_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_candidates_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId)
);
CREATE INDEX idx_candidates_user_id ON tblCandidates(iUserId);
CREATE INDEX idx_candidates_job_stage ON tblCandidates(iJobId, sCurrentStage);
CREATE INDEX idx_candidates_applied_at ON tblCandidates(dtAppliedAt);

CREATE TABLE tblCandidateStageHistory (
    iCandidateStageHistoryId INT IDENTITY(1,1) PRIMARY KEY,
    iCandidateId INT NOT NULL,
    iInterviewId INT,
    iJobId INT NOT NULL,
    sStage NVARCHAR(50) NOT NULL,
    iChangedBy INT NOT NULL,
    dtChangedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_candidate_stage_history_candidate FOREIGN KEY (iCandidateId) REFERENCES tblCandidates(iCandidateId),
    CONSTRAINT fk_candidate_stage_history_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId),
    CONSTRAINT fk_candidate_stage_history_changed_by FOREIGN KEY (iChangedBy) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_candidate_stage_history_candidate_id ON tblCandidateStageHistory(iCandidateId);
CREATE INDEX idx_candidate_stage_history_candidate_changed ON tblCandidateStageHistory(iCandidateId, dtChangedAt);

-- ====================================================================
-- TIME SLOT & AVAILABILITY MANAGEMENT
-- ====================================================================

CREATE TABLE tblTimeSlots (
    iTimeSlotId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255) NOT NULL,  -- e.g., "Morning Slot", "Early Afternoon"
    tStartTime TIME NOT NULL,
    tEndTime TIME NOT NULL,
    iDurationMinutes INT NOT NULL,
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_time_slots_is_active ON tblTimeSlots(bIsActive);

CREATE TABLE tblAvailability (
    iAvailabilityId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    dDate DATE NOT NULL,
    iTimeSlotId INT NOT NULL,
    bIsAvailable BIT DEFAULT 1,
    bIsBooked BIT DEFAULT 0,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_availability_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_availability_time_slot FOREIGN KEY (iTimeSlotId) REFERENCES tblTimeSlots(iTimeSlotId),
    CONSTRAINT uq_availability UNIQUE (iUserId, dDate, iTimeSlotId)
);
CREATE INDEX idx_availability_user_date ON tblAvailability(iUserId, dDate);
CREATE INDEX idx_availability_date_slot_available ON tblAvailability(dDate, iTimeSlotId, bIsAvailable);
CREATE INDEX idx_availability_is_booked ON tblAvailability(bIsBooked);

CREATE TABLE tblAvailabilityTemplates (
    iAvailabilityTemplateId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    iDayOfWeek INT NOT NULL,  -- 0-6 (Monday-Sunday)
    iTimeSlotId INT NOT NULL,
    bIsActive BIT DEFAULT 1,
    dValidFrom DATE,
    dValidUntil DATE,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_availability_templates_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_availability_templates_time_slot FOREIGN KEY (iTimeSlotId) REFERENCES tblTimeSlots(iTimeSlotId),
    CONSTRAINT uq_availability_templates UNIQUE (iUserId, iDayOfWeek, iTimeSlotId)
);
CREATE INDEX idx_availability_templates_user_active ON tblAvailabilityTemplates(iUserId, bIsActive);
CREATE INDEX idx_availability_templates_day_slot ON tblAvailabilityTemplates(iDayOfWeek, iTimeSlotId);

-- ====================================================================
-- INTERVIEW MANAGEMENT
-- ====================================================================

CREATE TABLE tblInterviews (
    iInterviewId INT IDENTITY(1,1) PRIMARY KEY,
    iCandidateId INT NOT NULL,
    iJobId INT NOT NULL,
    iAvailabilityId INT NOT NULL,
    dInterviewDate DATE NOT NULL,  -- denormalized for quick queries
    iTimeSlotId INT NOT NULL,  -- denormalized
    sTimezone NVARCHAR(100) NOT NULL,
    sStatus NVARCHAR(50) DEFAULT 'scheduled',  -- scheduled, completed, cancelled, rescheduled
    sMeetingLink NVARCHAR(MAX),
    sNotes NVARCHAR(MAX),
    iCreatedBy INT NOT NULL,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interviews_candidate FOREIGN KEY (iCandidateId) REFERENCES tblCandidates(iCandidateId),
    CONSTRAINT fk_interviews_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId),
    CONSTRAINT fk_interviews_availability FOREIGN KEY (iAvailabilityId) REFERENCES tblAvailability(iAvailabilityId),
    CONSTRAINT fk_interviews_time_slot FOREIGN KEY (iTimeSlotId) REFERENCES tblTimeSlots(iTimeSlotId),
    CONSTRAINT fk_interviews_created_by FOREIGN KEY (iCreatedBy) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_interviews_candidate_id ON tblInterviews(iCandidateId);
CREATE INDEX idx_interviews_job_id ON tblInterviews(iJobId);
CREATE INDEX idx_interviews_date_slot ON tblInterviews(dInterviewDate, iTimeSlotId);
CREATE INDEX idx_interviews_status ON tblInterviews(sStatus);
CREATE INDEX idx_interviews_created_by ON tblInterviews(iCreatedBy);

-- Add foreign key to tblCandidateStageHistory after tblInterviews table is created
ALTER TABLE tblCandidateStageHistory
ADD CONSTRAINT fk_candidate_stage_history_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId);
CREATE INDEX idx_candidate_stage_history_interview_id ON tblCandidateStageHistory(iInterviewId);

CREATE TABLE tblInterviewParticipants (
    iInterviewParticipantId INT IDENTITY(1,1) PRIMARY KEY,
    iInterviewId INT NOT NULL,
    iUserId INT NOT NULL,
    iRoleId INT NOT NULL,  -- interviewer, candidate
    sAttendanceStatus NVARCHAR(50),  -- attended, no_show, cancelled
    dtJoinedAt DATETIME2,
    dtLeftAt DATETIME2,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interview_participants_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId),
    CONSTRAINT fk_interview_participants_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_interview_participants_role FOREIGN KEY (iRoleId) REFERENCES tblRoles(iRoleId)
);
CREATE INDEX idx_interview_participants_interview_id ON tblInterviewParticipants(iInterviewId);
CREATE INDEX idx_interview_participants_user_id ON tblInterviewParticipants(iUserId);
CREATE INDEX idx_interview_participants_interview_user ON tblInterviewParticipants(iInterviewId, iUserId);

CREATE TABLE tblInterviewFeedback (
    iInterviewFeedbackId INT IDENTITY(1,1) PRIMARY KEY,
    iInterviewId INT NOT NULL,
    iInterviewerId INT NOT NULL,
    iRating INT,
    sDecision NVARCHAR(50),  -- hire, reject, maybe
    sComments NVARCHAR(MAX),
    sStrengths NVARCHAR(MAX),
    sWeaknesses NVARCHAR(MAX),
    dtSubmittedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interview_feedback_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId),
    CONSTRAINT fk_interview_feedback_interviewer FOREIGN KEY (iInterviewerId) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_interview_feedback_interview_id ON tblInterviewFeedback(iInterviewId);
CREATE INDEX idx_interview_feedback_interviewer_id ON tblInterviewFeedback(iInterviewerId);

-- ====================================================================
-- SCHEDULING & RESCHEDULING
-- ====================================================================

CREATE TABLE tblSchedulingAttempts (
    iSchedulingAttemptId INT IDENTITY(1,1) PRIMARY KEY,
    iCandidateId INT NOT NULL,
    iJobId INT NOT NULL,
    dtAttemptedAt DATETIME2 DEFAULT GETDATE(),
    bSuccess BIT DEFAULT 0,
    iMatchedAvailabilityId INT,  -- null if failed
    sFailureReason NVARCHAR(MAX),
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_scheduling_attempts_candidate FOREIGN KEY (iCandidateId) REFERENCES tblCandidates(iCandidateId),
    CONSTRAINT fk_scheduling_attempts_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId),
    CONSTRAINT fk_scheduling_attempts_availability FOREIGN KEY (iMatchedAvailabilityId) REFERENCES tblAvailability(iAvailabilityId)
);
CREATE INDEX idx_scheduling_attempts_candidate_id ON tblSchedulingAttempts(iCandidateId);
CREATE INDEX idx_scheduling_attempts_job_id ON tblSchedulingAttempts(iJobId);
CREATE INDEX idx_scheduling_attempts_attempted_at ON tblSchedulingAttempts(dtAttemptedAt);

CREATE TABLE tblRescheduleHistory (
    iRescheduleHistoryId INT IDENTITY(1,1) PRIMARY KEY,
    iInterviewId INT NOT NULL,
    iOldAvailabilityId INT NOT NULL,
    iNewAvailabilityId INT NOT NULL,
    sReason NVARCHAR(MAX),
    iRescheduledBy INT NOT NULL,
    dtRescheduledAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_reschedule_history_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId),
    CONSTRAINT fk_reschedule_history_old_availability FOREIGN KEY (iOldAvailabilityId) REFERENCES tblAvailability(iAvailabilityId),
    CONSTRAINT fk_reschedule_history_new_availability FOREIGN KEY (iNewAvailabilityId) REFERENCES tblAvailability(iAvailabilityId),
    CONSTRAINT fk_reschedule_history_rescheduled_by FOREIGN KEY (iRescheduledBy) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_reschedule_history_interview_id ON tblRescheduleHistory(iInterviewId);
CREATE INDEX idx_reschedule_history_rescheduled_at ON tblRescheduleHistory(dtRescheduledAt);

-- ====================================================================
-- NOTIFICATIONS & REMINDERS
-- ====================================================================

CREATE TABLE tblNotifications (
    iNotificationId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    iInterviewId INT,
    sType NVARCHAR(50) NOT NULL,  -- email, reminder, sms
    sContent NVARCHAR(MAX) NOT NULL,
    sStatus NVARCHAR(50) DEFAULT 'pending',  -- pending, sent, failed
    bRead BIT DEFAULT 0,
    dtReadAt DATETIME2,
    dtSentAt DATETIME2,
    iRetryCount INT DEFAULT 0,
    sErrorMessage NVARCHAR(MAX),
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_notifications_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_notifications_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId)
);
CREATE INDEX idx_notifications_user_read ON tblNotifications(iUserId, bRead);
CREATE INDEX idx_notifications_interview_id ON tblNotifications(iInterviewId);
CREATE INDEX idx_notifications_status_sent ON tblNotifications(sStatus, dtSentAt);

CREATE TABLE tblReminderQueue (
    iReminderQueueId INT IDENTITY(1,1) PRIMARY KEY,
    iInterviewId INT NOT NULL,
    dtReminderTime DATETIME2 NOT NULL,
    sReminderType NVARCHAR(50) NOT NULL,  -- 24h_before, 1h_before, 30m_before
    bProcessed BIT DEFAULT 0,
    dtProcessedAt DATETIME2,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_reminder_queue_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId)
);
CREATE INDEX idx_reminder_queue_processed_time ON tblReminderQueue(bProcessed, dtReminderTime);
CREATE INDEX idx_reminder_queue_interview_id ON tblReminderQueue(iInterviewId);

-- ====================================================================
-- CALENDAR INTEGRATION
-- ====================================================================

CREATE TABLE tblCalendarAccounts (
    iCalendarAccountId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    sProvider NVARCHAR(50) NOT NULL,  -- google, outlook, apple
    sExternalCalendarId NVARCHAR(255),
    sSyncStatus NVARCHAR(50) DEFAULT 'active',  -- active, inactive, error
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_calendar_accounts_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT uq_calendar_accounts UNIQUE (iUserId, sProvider)
);
CREATE INDEX idx_calendar_accounts_user_id ON tblCalendarAccounts(iUserId);

CREATE TABLE tblCalendarEvents (
    iCalendarEventId INT IDENTITY(1,1) PRIMARY KEY,
    iInterviewId INT NOT NULL,
    sProvider NVARCHAR(50) NOT NULL,
    sExternalEventId NVARCHAR(255),
    dtLastSyncedAt DATETIME2,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_calendar_events_interview FOREIGN KEY (iInterviewId) REFERENCES tblInterviews(iInterviewId)
);
CREATE INDEX idx_calendar_events_interview_id ON tblCalendarEvents(iInterviewId);
CREATE INDEX idx_calendar_events_external_event_id ON tblCalendarEvents(sExternalEventId);

-- ====================================================================
-- AUDIT & SYSTEM LOGS
-- ====================================================================

CREATE TABLE tblActivityLogs (
    iActivityLogId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT NOT NULL,
    sAction NVARCHAR(255) NOT NULL,
    sEntityType NVARCHAR(100) NOT NULL,
    iEntityId INT NOT NULL,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_activity_logs_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_activity_logs_user_created ON tblActivityLogs(iUserId, dtCreatedAt);
CREATE INDEX idx_activity_logs_entity ON tblActivityLogs(sEntityType, iEntityId);
CREATE INDEX idx_activity_logs_created_at ON tblActivityLogs(dtCreatedAt);

CREATE TABLE tblSystemJobs (
    iSystemJobId INT IDENTITY(1,1) PRIMARY KEY,
    sJobType NVARCHAR(100) NOT NULL,  -- reminder, cleanup, sync
    sStatus NVARCHAR(50) DEFAULT 'pending',  -- pending, running, completed, failed
    dtRunAt DATETIME2 NOT NULL,
    dtCompletedAt DATETIME2,
    sErrorMessage NVARCHAR(MAX),
    dtCreatedAt DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_system_jobs_status_run ON tblSystemJobs(sStatus, dtRunAt);
CREATE INDEX idx_system_jobs_job_type ON tblSystemJobs(sJobType);
-- ====================================================================
-- COMPANY MANAGEMENT
-- ====================================================================

CREATE TABLE tblCompanies (
    iCompanyId INT IDENTITY(1,1) PRIMARY KEY,
    sName NVARCHAR(255) NOT NULL,
    sIndustry NVARCHAR(100),
    sWebsite NVARCHAR(255),
    sAddress NVARCHAR(MAX),
    sCity NVARCHAR(100),
    sState NVARCHAR(100),
    sCountry NVARCHAR(100),
    sPostalCode NVARCHAR(20),
    sLogoUrl NVARCHAR(MAX),
    sPrimaryContactEmail NVARCHAR(255),
    sPrimaryContactPhone NVARCHAR(50),
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_companies_name ON tblCompanies(sName);
CREATE INDEX idx_companies_is_active ON tblCompanies(bIsActive);

-- ====================================================================
-- ROLE-SPECIFIC PROFILES
-- ====================================================================

CREATE TABLE tblInterviewers (
    iInterviewerId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT UNIQUE NOT NULL,
    iCompanyId INT NOT NULL,
    sTitle NVARCHAR(255),
    sDepartment NVARCHAR(255),
    sExpertiseAreas NVARCHAR(MAX),  -- JSON array or comma-separated
    iMaxInterviewsPerDay INT DEFAULT 3,
    iMaxInterviewsPerWeek INT DEFAULT 15,
    sPreferredInterviewDuration INT DEFAULT 60,  -- minutes
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interviewers_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_interviewers_company FOREIGN KEY (iCompanyId) REFERENCES tblCompanies(iCompanyId)
);
CREATE INDEX idx_interviewers_user_id ON tblInterviewers(iUserId);
CREATE INDEX idx_interviewers_company_id ON tblInterviewers(iCompanyId);
CREATE INDEX idx_interviewers_is_active ON tblInterviewers(bIsActive);

CREATE TABLE tblRecruiters (
    iRecruiterId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT UNIQUE NOT NULL,
    iCompanyId INT NOT NULL,
    sTitle NVARCHAR(255),
    sDepartment NVARCHAR(255),
    sSpecialization NVARCHAR(MAX),  -- e.g., "Technical, Engineering, Sales"
    iActiveJobsCount INT DEFAULT 0,
    iCandidatesHiredCount INT DEFAULT 0,
    bIsActive BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_recruiters_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId),
    CONSTRAINT fk_recruiters_company FOREIGN KEY (iCompanyId) REFERENCES tblCompanies(iCompanyId)
);
CREATE INDEX idx_recruiters_user_id ON tblRecruiters(iUserId);
CREATE INDEX idx_recruiters_company_id ON tblRecruiters(iCompanyId);
CREATE INDEX idx_recruiters_is_active ON tblRecruiters(bIsActive);

CREATE TABLE tblCandidateProfiles (
    iCandidateProfileId INT IDENTITY(1,1) PRIMARY KEY,
    iUserId INT UNIQUE NOT NULL,
    sLinkedInUrl NVARCHAR(500),
    sGithubUrl NVARCHAR(500),
    sPortfolioUrl NVARCHAR(500),
    sCurrentCompany NVARCHAR(255),
    sCurrentTitle NVARCHAR(255),
    iYearsOfExperience INT,
    sSkills NVARCHAR(MAX),  -- JSON array or comma-separated
    sEducation NVARCHAR(MAX),  -- JSON object
    sPreviousCompanies NVARCHAR(MAX),  -- JSON array
    sExpectedSalary NVARCHAR(100),
    sNoticePeriod NVARCHAR(100),  -- e.g., "Immediate", "30 days", "60 days"
    bIsOpenToRelocation BIT DEFAULT 0,
    bIsOpenToRemote BIT DEFAULT 1,
    dtCreatedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_candidate_profiles_user FOREIGN KEY (iUserId) REFERENCES tblUsers(iUserId)
);
CREATE INDEX idx_candidate_profiles_user_id ON tblCandidateProfiles(iUserId);

-- ====================================================================
-- JOB RECRUITER ASSIGNMENT
-- ====================================================================

CREATE TABLE tblJobRecruiters (
    iJobRecruiterId INT IDENTITY(1,1) PRIMARY KEY,
    iJobId INT NOT NULL,
    iRecruiterId INT NOT NULL,
    bIsPrimaryRecruiter BIT DEFAULT 0,  -- one primary recruiter per job
    dtAssignedAt DATETIME2 DEFAULT GETDATE(),
    dtUpdatedAt DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_job_recruiters_job FOREIGN KEY (iJobId) REFERENCES tblJobs(iJobId),
    CONSTRAINT fk_job_recruiters_recruiter FOREIGN KEY (iRecruiterId) REFERENCES tblRecruiters(iRecruiterId),
    CONSTRAINT uq_job_recruiters UNIQUE (iJobId, iRecruiterId)
);
CREATE INDEX idx_job_recruiters_job_id ON tblJobRecruiters(iJobId);
CREATE INDEX idx_job_recruiters_recruiter_id ON tblJobRecruiters(iRecruiterId);
CREATE INDEX idx_job_recruiters_primary ON tblJobRecruiters(iJobId, bIsPrimaryRecruiter);

-- Add company reference to tblUsers
ALTER TABLE tblUsers
ADD iCompanyId INT NULL,
    CONSTRAINT fk_users_company FOREIGN KEY (iCompanyId) REFERENCES tblCompanies(iCompanyId);
CREATE INDEX idx_users_company_id ON tblUsers(iCompanyId);

-- Add company reference to tblJobs
ALTER TABLE tblJobs
ADD iCompanyId INT NOT NULL,
    CONSTRAINT fk_jobs_company FOREIGN KEY (iCompanyId) REFERENCES tblCompanies(iCompanyId);
CREATE INDEX idx_jobs_company_id ON tblJobs(iCompanyId);

-- Update tblJobInterviewers to reference tblInterviewers instead of tblUsers
ALTER TABLE tblJobInterviewers
DROP CONSTRAINT fk_job_interviewers_interviewer;

ALTER TABLE tblJobInterviewers
ADD CONSTRAINT fk_job_interviewers_interviewer 
    FOREIGN KEY (iInterviewerId) REFERENCES tblInterviewers(iInterviewerId);

-- ====================================================================
-- SCHEMA NOTES
-- ====================================================================

/*
NAMING CONVENTIONS APPLIED:
- Tables: tbl prefix (e.g., tblUsers, tblJobs)
- INT fields: i prefix (e.g., iUserId, iJobId)
- NVARCHAR/String fields: s prefix (e.g., sName, sEmail)
- BIT/Boolean fields: b prefix (e.g., bIsActive, bRead)
- DATETIME2 fields: dt prefix (e.g., dtCreatedAt, dtUpdatedAt)
- DATE fields: d prefix (e.g., dDate, dInterviewDate)
- TIME fields: t prefix (e.g., tStartTime, tEndTime)

UNIQUE CONSTRAINTS (enforced at database level):
- tblUsers.sEmail
- tblRoles.sName
- tblUserPreferences.iUserId
- tblJobInterviewers(iJobId, iInterviewerId)
- tblAvailability(iUserId, dDate, iTimeSlotId)
- tblAvailabilityTemplates(iUserId, iDayOfWeek, iTimeSlotId)
- tblCalendarAccounts(iUserId, sProvider)

BUSINESS RULES (enforced at application level):
1. Cannot schedule interview on unavailable slot (bIsAvailable = 0)
2. Cannot double-book availability (bIsBooked = 1)
3. Interview timezone should match candidate's preferred timezone
4. Reminders must be sent before interview time
5. Stage transitions must follow logical order
6. Feedback can only be submitted after interview is completed
7. Rescheduling requires both old and new availability to be valid

DEFAULT VALUES:
- Most boolean flags (BIT) default to 1 for active state
- Status fields default to 'active' or 'pending'
- Timestamps default to current time (GETDATE())
- Counters (iRetryCount) default to 0

PERFORMANCE CONSIDERATIONS:
- Composite indexes on frequently queried combinations
- Denormalization in tblInterviews table (dInterviewDate, iTimeSlotId) for faster queries
- Separate history/log tables to keep main tables lean
- Indexes on foreign keys for join performance

SCALABILITY NOTES:
- Consider partitioning tblActivityLogs by date for large datasets
- Archive old interviews/candidates after defined period
- Implement soft deletes via bIsActive flags
- Use read replicas for reporting queries
*/