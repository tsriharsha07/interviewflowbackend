import bcrypt from "bcrypt";

const SALT_ROUNDS = 12;

/**
 * Generate hashed password
 * @param {string} plainPassword
 * @returns {Promise<string>}
 */
const hashPassword = async (plainPassword) => {
  if (!plainPassword) {
    throw new Error("Password is required");
  }

  const hashedPassword = await bcrypt.hash(plainPassword, SALT_ROUNDS);
  return hashedPassword;
};

/**
 * Validate password
 * @param {string} plainPassword
 * @param {string} hashedPassword
 * @returns {Promise<boolean>}
 */
const comparePassword = async (plainPassword, hashedPassword) => {
  if (!plainPassword || !hashedPassword) {
    throw new Error("Both passwords are required");
  }

  return await bcrypt.compare(plainPassword, hashedPassword);
};
export { hashPassword, comparePassword };
