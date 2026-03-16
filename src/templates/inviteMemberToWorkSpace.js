export const getWorkspaceInviteEmail = ({
  inviterName,
  workspaceName,
  inviteLink,
  expiryHours = 48,
}) => {
  return `
  <div style="background:#f4f6f8;padding:40px;font-family:Arial,Helvetica,sans-serif;">
    
    <div style="max-width:600px;margin:auto;background:white;border-radius:8px;padding:40px;">
      
      <h2 style="margin:0;color:#333;">You're invited 🎉</h2>

      <p style="color:#555;font-size:15px;line-height:1.6;margin-top:20px;">
        <strong>${inviterName}</strong> invited you to join the workspace 
        <strong>${workspaceName}</strong>.
      </p>

      <div style="text-align:center;margin:30px 0;">
        <a href="${inviteLink}"
           style="background:#4f46e5;color:white;text-decoration:none;
           padding:12px 28px;border-radius:6px;font-weight:bold;font-size:15px;">
           Accept Invitation
        </a>
      </div>

      <p style="color:#666;font-size:14px;">
        This invitation will expire in <strong>${expiryHours} hours</strong>.
      </p>

      <p style="font-size:13px;color:#888;">
        If the button doesn't work, copy this link into your browser:
      </p>

      <p style="word-break:break-all;color:#4f46e5;font-size:13px;">
        ${inviteLink}
      </p>

      <hr style="margin:30px 0;border:none;border-top:1px solid #eee"/>

      <p style="font-size:12px;color:#aaa;text-align:center;">
        © ${new Date().getFullYear()} My App
      </p>

    </div>
  </div>
  `;
};
