const bcrypt = require("bcrypt");
const { getClient } = require("../config/database");
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const validator = require("validator");

async function register(req, res) {
  const client = getClient();
  const db = client.db();
  const { firstName, lastName, email, password } = req.body;

  if (!firstName || !lastName || !email || !password) {
    return res.status(400).send({ message: "All fields are required" });
  }
  if (!validator.isEmail(email)) {
    return res.status(400).send({ message: "Invalid email format" });
  }
  if (password.length < 8) {
    return res
      .status(400)
      .send({ message: "Password must be at least 8 characters long" });
  }

  try {
    const existingUser = await db.collection("users").findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .send({ message: "User with this email already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    await db.collection("users").insertOne({
      firstName,
      lastName,
      email,
      password: hashedPassword,
      createdAt: new Date(),
      updateAt: new Date(),
    });

    res.status(201).send({ message: "User registered successfully" });
  } catch (error) {
    console.error("Error registering user:", error);
    res.status(500).send({ message: "Internal Server Error" });
  }
}

async function login(req, res) {
  const client = getClient();
  const db = client.db();
  const { email, password } = req.body;

  const user = await db.collection("users").findOne({ email });
  if (!user) {
    return res.status(401).send({ message: "Invalid email or password" });
  }

  const match = await bcrypt.compare(password, user.password);
  if (!match) {
    return res.status(401).send({ message: "Invalid email or password" });
  }

  const accessToken = jwt.sign(
    { userId: user._id, email: user.email },
    process.env.ACCESS_TOKEN_SECRET,
    { expiresIn: "15m" }
  );
  const refreshToken = jwt.sign(
    { userId: user._id, email: user.email },
    process.env.REFRESH_TOKEN_SECRET,
    { expiresIn: "7d" }
  );

  await db.collection("refreshTokens").insertOne({
    token: refreshToken,
    expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days validity
  });

  const response = {
    message: "Login successful",
    user: {
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      userId: user._id,
    },
    accessToken,
  };

  console.log(response);
  res.status(200).send(response);
}

async function logout(req, res) {
  const { refreshToken } = req.body;
  const client = getClient();
  const db = client.db();
  await db.collection("refreshTokens").deleteOne({ token: refreshToken });
  res.status(200).send({ message: "Logout successful" });
}

const generateRandomCode = () => {
  return Math.floor(100000 + Math.random() * 900000);
};

const transporter = nodemailer.createTransport({
  host: "smtp.zoho.com",
  port: 465,
  secure: true,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

const forgotPassword = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res
      .status(400)
      .send({ message: "Email is required for password reset" });
  }

  const client = getClient();
  const users = client.db().collection("users");
  const resetEmails = client.db().collection("storeEmails");

  try {
    const foundUser = await users.findOne({ email });

    if (!foundUser) {
      return res
        .status(404)
        .send({ message: "User not found with the provided email" });
    }

    const resetCode = generateRandomCode();
    const hashedCode = await bcrypt.hash(resetCode.toString(), 10);

    foundUser.resetPasswordCode = hashedCode;
    foundUser.resetPasswordExpires = Date.now() + 3600000; // 1 hour expiration

    await users.updateOne({ email }, { $set: foundUser });

    await resetEmails.insertOne({
      email,
      resetCode: resetCode,
      expiresAt: foundUser.resetPasswordExpires,
    });

    const mailOptions = {
      from: '"No-reply: Support team" <' + process.env.EMAIL_USER + ">",
      to: email,
      subject: "Password Reset Code",
      html: `
        <p>Hello,</p>
        <p>Use the following code to reset your password:</p>
        <h3>${resetCode}</h3>
      `,
    };

    const info = await transporter.sendMail(mailOptions);

    if (info.response) {
      console.log("Email sent:", info.response);
      return res.send({
        message:
          "Reset code generated successfully. Check your email for the code.",
        resetCode,
      });
    } else {
      console.error("Error sending email");
      return res.status(500).send({ message: "Error sending email" });
    }
  } catch (error) {
    console.error("Error generating reset code:", error);
    return res.status(500).send({ message: "Internal Server Error" });
  }
};

const verifyResetCode = async (req, res) => {
  const { code } = req.body;

  if (!code) {
    return res.status(400).send({ message: "Code is required" });
  }

  const client = getClient();
  const users = client.db().collection("users");

  try {
    const usersWithResetCode = await users
      .find({
        resetPasswordCode: { $exists: true },
      })
      .toArray();

    const foundUser = usersWithResetCode.find((user) => {
      return bcrypt.compareSync(code.toString(), user.resetPasswordCode);
    });

    if (!foundUser) {
      return res
        .status(404)
        .send({ message: "No user found with the provided code" });
    }

    if (Date.now() > foundUser.resetPasswordExpires) {
      return res.status(400).send({ message: "Reset code has expired" });
    }

    res.status(200).send({ message: "Reset code verified successfully" });
  } catch (error) {
    console.error("Error verifying reset code:", error);
    res.status(500).send({ message: "Internal Server Error" });
  }
};

const resetPassword = async (req, res) => {
  const { newPassword, confirmPassword } = req.body;

  if (!newPassword || !confirmPassword) {
    return res.status(400).send({
      message: "Both newPassword and confirmPassword are required",
    });
  }

  if (newPassword !== confirmPassword) {
    return res.status(400).send({ message: "Passwords do not match" });
  }

  const client = getClient();
  const storeEmails = client.db().collection("storeEmails");
  const users = client.db().collection("users");

  try {
    const { email } = await storeEmails.findOne({}, { sort: { $natural: -1 } });

    if (!email) {
      return res
        .status(404)
        .send({ message: "No email found in storeEmails collection" });
    }
    const foundUser = await users.findOne({ email });

    if (!foundUser) {
      return res
        .status(404)
        .send({ message: "No user found with the provided email" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    await users.updateOne({ email }, { $set: { password: hashedPassword } });
    await storeEmails.drop();
    return res.status(200).send({ message: "Password reset successful" });
  } catch (error) {
    console.error("Error resetting password:", error);
    return res.status(500).send({ message: "Internal Server Error" });
  }
};

module.exports = {
  register,
  login,
  logout,
  forgotPassword,
  verifyResetCode,
  resetPassword,
};
