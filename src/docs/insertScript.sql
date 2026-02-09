-- ================================================
-- INSERT STATEMENTS FOR INTERVIEWFLOW RBAC SYSTEM
-- ================================================

-- ================================================
-- 1. ROLES
-- ================================================
INSERT INTO tblRoles (sName, sDescription, bIsActive) VALUES
('Admin', 'System administrator with full access to all features and configurations', 1),
('Recruiter', 'HR personnel managing job postings, candidates, and interview scheduling', 1),
('Interviewer', 'Conducts interviews and provides feedback on candidates', 1),
('Candidate', 'Job applicant participating in interviews', 1);

-- ================================================
-- 2. MODULES (Organized for Sidebar Navigation)
-- ================================================
INSERT INTO tblModules (sName, sDescription) VALUES
-- Core/Shared Modules
('Dashboard', 'Role-specific dashboard with key metrics and overview'),
('Profile', 'User profile management and account settings'),
('Notifications', 'System notifications and alerts'),
('Calendar', 'Interview calendar with timezone-aware scheduling'),

-- Admin Specific
('User Management', 'Manage all system users and their roles'),
('Organization Management', 'Manage companies and hiring teams'),
('Role & Permission Management', 'Configure roles and permissions'),
('System Configuration', 'System-wide settings and configurations'),
('Reports & Analytics', 'System-wide reports and analytics'),

-- Recruiter Specific
('Job Management', 'Create and manage job openings and hiring pipelines'),
('Candidate Management', 'Manage candidates and their applications'),
('Interview Scheduling', 'Schedule and manage interviews'),
('Feedback Management', 'View and manage interview feedback'),

-- Interviewer Specific
('Availability Management', 'Set and manage interviewer availability'),
('Interview Details', 'View assigned interview details'),
('Feedback Submission', 'Submit interview feedback and ratings'),

-- Candidate Specific
('Interview Timeline', 'View interview schedule and status'),
('Slot Selection', 'Choose interview time slots'),
('Reschedule Request', 'Request interview rescheduling'),
('Interview Information', 'View interview details and information');

-- ================================================
-- 3. PERMISSIONS
-- ================================================
INSERT INTO tblPermissions (sName) VALUES
-- CRUD Permissions
('View'),
('Create'),
('Edit'),
('Delete'),
('Export'),
('Import'),

-- Specific Action Permissions
('Schedule'),
('Reschedule'),
('Cancel'),
('Approve'),
('Reject'),
('Assign'),
('Submit'),
('Download'),
('Configure'),
('Activate'),
('Deactivate');

-- ================================================
-- 4. ROLE-PERMISSION-MODULE MAPPING
-- ================================================

-- ================================================
-- ADMIN PERMISSIONS
-- ================================================

-- Dashboard Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Dashboard'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- Profile Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Profile'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Edit');

-- Notifications Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Notifications'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Configure');

-- Calendar Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Calendar'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- User Management Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'User Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete', 'Assign', 'Activate', 'Deactivate', 'Export');

-- Organization Management Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Organization Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete', 'Assign');

-- Role & Permission Management Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Role & Permission Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete', 'Assign');

-- System Configuration Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'System Configuration'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Edit', 'Configure');

-- Reports & Analytics Module (Admin)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Admin'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Reports & Analytics'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- ================================================
-- RECRUITER PERMISSIONS
-- ================================================

-- Dashboard Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Dashboard'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- Profile Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Profile'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Edit');

-- Notifications Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Notifications'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Calendar Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Calendar'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- Job Management Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Job Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete', 'Assign');

-- Candidate Management Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Candidate Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete', 'Import', 'Export', 'Download');

-- Interview Scheduling Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Interview Scheduling'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Schedule', 'Reschedule', 'Cancel', 'Approve', 'Reject');

-- Feedback Management Module (Recruiter)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Recruiter'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Feedback Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Export');

-- ================================================
-- INTERVIEWER PERMISSIONS
-- ================================================

-- Dashboard Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Dashboard'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Profile Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Profile'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Edit');

-- Notifications Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Notifications'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Calendar Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Calendar'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Availability Management Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Availability Management'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Delete');

-- Interview Details Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Interview Details'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Download');

-- Feedback Submission Module (Interviewer)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Interviewer'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Feedback Submission'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create', 'Edit', 'Submit');

-- ================================================
-- CANDIDATE PERMISSIONS
-- ================================================

-- Dashboard Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Dashboard'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Profile Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Profile'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Edit');

-- Notifications Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Notifications'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Calendar Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Calendar'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Interview Timeline Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Interview Timeline'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View');

-- Slot Selection Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Slot Selection'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create');

-- Reschedule Request Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Reschedule Request'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Create');

-- Interview Information Module (Candidate)
INSERT INTO tblRolePermissions (iRoleId, iModuleId, iPermissionId)
SELECT 
    (SELECT iRoleId FROM tblRoles WHERE sName = 'Candidate'),
    (SELECT iModuleId FROM tblModules WHERE sName = 'Interview Information'),
    iPermissionId
FROM tblPermissions WHERE sName IN ('View', 'Download');

-- ================================================
-- VERIFICATION QUERIES
-- ================================================

-- View all roles
-- SELECT * FROM tblRoles;

-- View all modules
-- SELECT * FROM tblModules ORDER BY sName;

-- View all permissions
-- SELECT * FROM tblPermissions ORDER BY sName;

-- View role-permission-module mapping
-- SELECT 
--     r.sName AS RoleName,
--     m.sName AS ModuleName,
--     p.sName AS PermissionName
-- FROM tblRolePermissions rp
-- INNER JOIN tblRoles r ON rp.iRoleId = r.iRoleId
-- INNER JOIN tblModules m ON rp.iModuleId = m.iModuleId
-- INNER JOIN tblPermissions p ON rp.iPermissionId = p.iPermissionId
-- ORDER BY r.sName, m.sName, p.sName;

-- View permissions by role
SELECT 
r.sName AS RoleName,
m.sName AS ModuleName,
STRING_AGG(p.sName, ', ') AS Permissions
FROM tblRolePermissions rp
INNER JOIN tblRoles r ON rp.iRoleId = r.iRoleId
INNER JOIN tblModules m ON rp.iModuleId = m.iModuleId
INNER JOIN tblPermissions p ON rp.iPermissionId = p.iPermissionId
GROUP BY r.sName, m.sName
ORDER BY r.sName, m.sName;

