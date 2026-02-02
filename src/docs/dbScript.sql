-- ====================================================================
-- AUTOMATED INTERVIEW SCHEDULING PLATFORM - MSSQL DATABASE SCHEMA
-- ====================================================================
-- Converted from DBML to MSSQL Server T-SQL
-- ====================================================================

-- ====================================================================
-- CORE USER MANAGEMENT
-- ====================================================================

CREATE TABLE roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_roles_name ON roles(name);

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    timezone NVARCHAR(100),
    phone NVARCHAR(50),
    is_active BIT DEFAULT 1,
    last_login DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_is_active ON users(is_active);

CREATE TABLE modules (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE permissions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE role_permissions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    permission_id INT,
    module_id INT,
    role_id INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id),
    CONSTRAINT fk_role_permissions_module FOREIGN KEY (module_id) REFERENCES modules(id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE user_preferences (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    email_notifications BIT DEFAULT 1,
    reminder_frequency NVARCHAR(50) DEFAULT '24h',
    calendar_sync_enabled BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_user_preferences_user FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);

-- ====================================================================
-- JOB MANAGEMENT
-- ====================================================================

CREATE TABLE jobs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    department NVARCHAR(255),
    description NVARCHAR(MAX),
    location NVARCHAR(255),  -- remote, office, hybrid
    created_by INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    closed_at DATETIME2,
    CONSTRAINT fk_jobs_created_by FOREIGN KEY (created_by) REFERENCES users(id)
);
CREATE INDEX idx_jobs_created_by ON jobs(created_by);

CREATE TABLE job_interviewers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_id INT NOT NULL,
    interviewer_id INT NOT NULL,
    assigned_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_job_interviewers_job FOREIGN KEY (job_id) REFERENCES jobs(id),
    CONSTRAINT fk_job_interviewers_interviewer FOREIGN KEY (interviewer_id) REFERENCES users(id),
    CONSTRAINT uq_job_interviewers UNIQUE (job_id, interviewer_id)
);
CREATE INDEX idx_job_interviewers_job_id ON job_interviewers(job_id);
CREATE INDEX idx_job_interviewers_interviewer_id ON job_interviewers(interviewer_id);

-- ====================================================================
-- CANDIDATE MANAGEMENT
-- ====================================================================

CREATE TABLE candidates (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    job_id INT NOT NULL,
    current_stage NVARCHAR(50) DEFAULT 'applied',  -- applied, screening, scheduled, completed, rejected
    resume_url NVARCHAR(MAX),
    notes NVARCHAR(MAX),
    rejection_reason NVARCHAR(MAX),
    applied_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_candidates_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_candidates_job FOREIGN KEY (job_id) REFERENCES jobs(id)
);
CREATE INDEX idx_candidates_user_id ON candidates(user_id);
CREATE INDEX idx_candidates_job_stage ON candidates(job_id, current_stage);
CREATE INDEX idx_candidates_applied_at ON candidates(applied_at);

CREATE TABLE candidate_stage_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    candidate_id INT NOT NULL,
    interview_id INT,
    job_id INT NOT NULL,
    stage NVARCHAR(50) NOT NULL,
    changed_by INT NOT NULL,
    changed_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_candidate_stage_history_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    CONSTRAINT fk_candidate_stage_history_job FOREIGN KEY (job_id) REFERENCES jobs(id),
    CONSTRAINT fk_candidate_stage_history_changed_by FOREIGN KEY (changed_by) REFERENCES users(id)
);
CREATE INDEX idx_candidate_stage_history_candidate_id ON candidate_stage_history(candidate_id);
CREATE INDEX idx_candidate_stage_history_candidate_changed ON candidate_stage_history(candidate_id, changed_at);

-- ====================================================================
-- TIME SLOT & AVAILABILITY MANAGEMENT
-- ====================================================================

CREATE TABLE time_slots (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,  -- e.g., "Morning Slot", "Early Afternoon"
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_time_slots_is_active ON time_slots(is_active);

CREATE TABLE availability (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    date DATE NOT NULL,
    time_slot_id INT NOT NULL,
    is_available BIT DEFAULT 1,
    is_booked BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_availability_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_availability_time_slot FOREIGN KEY (time_slot_id) REFERENCES time_slots(id),
    CONSTRAINT uq_availability UNIQUE (user_id, date, time_slot_id)
);
CREATE INDEX idx_availability_user_date ON availability(user_id, date);
CREATE INDEX idx_availability_date_slot_available ON availability(date, time_slot_id, is_available);
CREATE INDEX idx_availability_is_booked ON availability(is_booked);

CREATE TABLE availability_templates (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    day_of_week INT NOT NULL,  -- 0-6 (Monday-Sunday)
    time_slot_id INT NOT NULL,
    is_active BIT DEFAULT 1,
    valid_from DATE,
    valid_until DATE,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_availability_templates_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_availability_templates_time_slot FOREIGN KEY (time_slot_id) REFERENCES time_slots(id),
    CONSTRAINT uq_availability_templates UNIQUE (user_id, day_of_week, time_slot_id)
);
CREATE INDEX idx_availability_templates_user_active ON availability_templates(user_id, is_active);
CREATE INDEX idx_availability_templates_day_slot ON availability_templates(day_of_week, time_slot_id);

-- ====================================================================
-- INTERVIEW MANAGEMENT
-- ====================================================================

CREATE TABLE interviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    candidate_id INT NOT NULL,
    job_id INT NOT NULL,
    availability_id INT NOT NULL,
    interview_date DATE NOT NULL,  -- denormalized for quick queries
    time_slot_id INT NOT NULL,  -- denormalized
    timezone NVARCHAR(100) NOT NULL,
    status NVARCHAR(50) DEFAULT 'scheduled',  -- scheduled, completed, cancelled, rescheduled
    meeting_link NVARCHAR(MAX),
    notes NVARCHAR(MAX),
    created_by INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interviews_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    CONSTRAINT fk_interviews_job FOREIGN KEY (job_id) REFERENCES jobs(id),
    CONSTRAINT fk_interviews_availability FOREIGN KEY (availability_id) REFERENCES availability(id),
    CONSTRAINT fk_interviews_time_slot FOREIGN KEY (time_slot_id) REFERENCES time_slots(id),
    CONSTRAINT fk_interviews_created_by FOREIGN KEY (created_by) REFERENCES users(id)
);
CREATE INDEX idx_interviews_candidate_id ON interviews(candidate_id);
CREATE INDEX idx_interviews_job_id ON interviews(job_id);
CREATE INDEX idx_interviews_date_slot ON interviews(interview_date, time_slot_id);
CREATE INDEX idx_interviews_status ON interviews(status);
CREATE INDEX idx_interviews_created_by ON interviews(created_by);

-- Add foreign key to candidate_stage_history after interviews table is created
ALTER TABLE candidate_stage_history
ADD CONSTRAINT fk_candidate_stage_history_interview FOREIGN KEY (interview_id) REFERENCES interviews(id);
CREATE INDEX idx_candidate_stage_history_interview_id ON candidate_stage_history(interview_id);

CREATE TABLE interview_participants (
    id INT IDENTITY(1,1) PRIMARY KEY,
    interview_id INT NOT NULL,
    user_id INT NOT NULL,
    role_id INT NOT NULL,  -- interviewer, candidate
    attendance_status NVARCHAR(50),  -- attended, no_show, cancelled
    joined_at DATETIME2,
    left_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interview_participants_interview FOREIGN KEY (interview_id) REFERENCES interviews(id),
    CONSTRAINT fk_interview_participants_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_interview_participants_role FOREIGN KEY (role_id) REFERENCES roles(id)
);
CREATE INDEX idx_interview_participants_interview_id ON interview_participants(interview_id);
CREATE INDEX idx_interview_participants_user_id ON interview_participants(user_id);
CREATE INDEX idx_interview_participants_interview_user ON interview_participants(interview_id, user_id);

CREATE TABLE interview_feedback (
    id INT IDENTITY(1,1) PRIMARY KEY,
    interview_id INT NOT NULL,
    interviewer_id INT NOT NULL,
    rating INT,
    decision NVARCHAR(50),  -- hire, reject, maybe
    comments NVARCHAR(MAX),
    strengths NVARCHAR(MAX),
    weaknesses NVARCHAR(MAX),
    submitted_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_interview_feedback_interview FOREIGN KEY (interview_id) REFERENCES interviews(id),
    CONSTRAINT fk_interview_feedback_interviewer FOREIGN KEY (interviewer_id) REFERENCES users(id)
);
CREATE INDEX idx_interview_feedback_interview_id ON interview_feedback(interview_id);
CREATE INDEX idx_interview_feedback_interviewer_id ON interview_feedback(interviewer_id);

-- ====================================================================
-- SCHEDULING & RESCHEDULING
-- ====================================================================

CREATE TABLE scheduling_attempts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    candidate_id INT NOT NULL,
    job_id INT NOT NULL,
    attempted_at DATETIME2 DEFAULT GETDATE(),
    success BIT DEFAULT 0,
    matched_availability_id INT,  -- null if failed
    failure_reason NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_scheduling_attempts_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    CONSTRAINT fk_scheduling_attempts_job FOREIGN KEY (job_id) REFERENCES jobs(id),
    CONSTRAINT fk_scheduling_attempts_availability FOREIGN KEY (matched_availability_id) REFERENCES availability(id)
);
CREATE INDEX idx_scheduling_attempts_candidate_id ON scheduling_attempts(candidate_id);
CREATE INDEX idx_scheduling_attempts_job_id ON scheduling_attempts(job_id);
CREATE INDEX idx_scheduling_attempts_attempted_at ON scheduling_attempts(attempted_at);

CREATE TABLE reschedule_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    interview_id INT NOT NULL,
    old_availability_id INT NOT NULL,
    new_availability_id INT NOT NULL,
    reason NVARCHAR(MAX),
    rescheduled_by INT NOT NULL,
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_reschedule_history_interview FOREIGN KEY (interview_id) REFERENCES interviews(id),
    CONSTRAINT fk_reschedule_history_old_availability FOREIGN KEY (old_availability_id) REFERENCES availability(id),
    CONSTRAINT fk_reschedule_history_new_availability FOREIGN KEY (new_availability_id) REFERENCES availability(id),
    CONSTRAINT fk_reschedule_history_rescheduled_by FOREIGN KEY (rescheduled_by) REFERENCES users(id)
);
CREATE INDEX idx_reschedule_history_interview_id ON reschedule_history(interview_id);
CREATE INDEX idx_reschedule_history_updated_at ON reschedule_history(updated_at);

-- ====================================================================
-- NOTIFICATIONS & REMINDERS
-- ====================================================================

CREATE TABLE notifications (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    interview_id INT,
    type NVARCHAR(50) NOT NULL,  -- email, reminder, sms
    content NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(50) DEFAULT 'pending',  -- pending, sent, failed
    read BIT DEFAULT 0,
    read_at DATETIME2,
    sent_at DATETIME2,
    retry_count INT DEFAULT 0,
    error_message NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_notifications_interview FOREIGN KEY (interview_id) REFERENCES interviews(id)
);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, read);
CREATE INDEX idx_notifications_interview_id ON notifications(interview_id);
CREATE INDEX idx_notifications_status_sent ON notifications(status, sent_at);

CREATE TABLE reminder_queue (
    id INT IDENTITY(1,1) PRIMARY KEY,
    interview_id INT NOT NULL,
    reminder_time DATETIME2 NOT NULL,
    reminder_type NVARCHAR(50) NOT NULL,  -- 24h_before, 1h_before, 30m_before
    processed BIT DEFAULT 0,
    processed_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_reminder_queue_interview FOREIGN KEY (interview_id) REFERENCES interviews(id)
);
CREATE INDEX idx_reminder_queue_processed_time ON reminder_queue(processed, reminder_time);
CREATE INDEX idx_reminder_queue_interview_id ON reminder_queue(interview_id);

-- ====================================================================
-- CALENDAR INTEGRATION
-- ====================================================================

CREATE TABLE calendar_accounts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    provider NVARCHAR(50) NOT NULL,  -- google, outlook, apple
    external_calendar_id NVARCHAR(255),
    sync_status NVARCHAR(50) DEFAULT 'active',  -- active, inactive, error
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_calendar_accounts_user FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT uq_calendar_accounts UNIQUE (user_id, provider)
);
CREATE INDEX idx_calendar_accounts_user_id ON calendar_accounts(user_id);

CREATE TABLE calendar_events (
    id INT IDENTITY(1,1) PRIMARY KEY,
    interview_id INT NOT NULL,
    provider NVARCHAR(50) NOT NULL,
    external_event_id NVARCHAR(255),
    last_synced_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_calendar_events_interview FOREIGN KEY (interview_id) REFERENCES interviews(id)
);
CREATE INDEX idx_calendar_events_interview_id ON calendar_events(interview_id);
CREATE INDEX idx_calendar_events_external_event_id ON calendar_events(external_event_id);

-- ====================================================================
-- AUDIT & SYSTEM LOGS
-- ====================================================================

CREATE TABLE activity_logs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    action NVARCHAR(255) NOT NULL,
    entity_type NVARCHAR(100) NOT NULL,
    entity_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_activity_logs_user FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE INDEX idx_activity_logs_user_created ON activity_logs(user_id, created_at);
CREATE INDEX idx_activity_logs_entity ON activity_logs(entity_type, entity_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

CREATE TABLE system_jobs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_type NVARCHAR(100) NOT NULL,  -- reminder, cleanup, sync
    status NVARCHAR(50) DEFAULT 'pending',  -- pending, running, completed, failed
    run_at DATETIME2 NOT NULL,
    completed_at DATETIME2,
    error_message NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE()
);
CREATE INDEX idx_system_jobs_status_run ON system_jobs(status, run_at);
CREATE INDEX idx_system_jobs_job_type ON system_jobs(job_type);

-- ====================================================================
-- SCHEMA NOTES
-- ====================================================================

/*
UNIQUE CONSTRAINTS (enforced at database level):
- users.email
- roles.name
- user_preferences.user_id
- job_interviewers(job_id, interviewer_id)
- availability(user_id, date, time_slot_id)
- availability_templates(user_id, day_of_week, time_slot_id)
- calendar_accounts(user_id, provider)

BUSINESS RULES (enforced at application level):
1. Cannot schedule interview on unavailable slot (is_available = 0)
2. Cannot double-book availability (is_booked = 1)
3. Interview timezone should match candidate's preferred timezone
4. Reminders must be sent before interview time
5. Stage transitions must follow logical order
6. Feedback can only be submitted after interview is completed
7. Rescheduling requires both old and new availability to be valid

DEFAULT VALUES:
- Most boolean flags (BIT) default to 1 for active state
- Status fields default to 'active' or 'pending'
- Timestamps default to current time (GETDATE())
- Counters (retry_count) default to 0

PERFORMANCE CONSIDERATIONS:
- Composite indexes on frequently queried combinations
- Denormalization in interviews table (date, time_slot_id) for faster queries
- Separate history/log tables to keep main tables lean
- Indexes on foreign keys for join performance

SCALABILITY NOTES:
- Consider partitioning activity_logs by date for large datasets
- Archive old interviews/candidates after defined period
- Implement soft deletes via is_active flags
- Use read replicas for reporting queries
*/