import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_USER, // your Gmail address
    pass: process.env.GMAIL_APP_PASSWORD, // App Password (not your real password)
  },
});

transporter.verify((error) => {
  if (error) console.error("SMTP connection failed:", error);
  else console.log("SMTP ready");
});

export async function sendMail({ to, subject, text, html }) {
  return await transporter.sendMail({
    from: `"My App" <${process.env.GMAIL_USER}>`,
    to,
    subject,
    text,
    html,
  });
}
