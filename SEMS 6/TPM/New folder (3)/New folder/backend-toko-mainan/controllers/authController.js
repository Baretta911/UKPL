// controllers/authController.js

import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { User } from "../models/index.js";

const register = async (req, res) => {
  const { nim, name, email, password } = req.body;
  try {
    const existingUser = await User.findOne({ where: { nim } });
    if (existingUser) {
      return res.status(400).json({ message: "NIM sudah terdaftar" });
    }
    const existingEmail = await User.findOne({ where: { email } });
    if (existingEmail) {
      return res.status(400).json({ message: "Email sudah terdaftar" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await User.create({
      nim,
      name,
      email,
      password: hashedPassword,
    });

    res.status(201).json({ message: "Registrasi berhasil" });
  } catch (error) {
    console.error("Register error:", error); // Tambahkan log error detail
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

const login = async (req, res) => {
  const { nim, password } = req.body;
  try {
    const user = await User.findOne({ where: { nim } });
    if (!user) {
      return res.status(401).json({ message: "NIM or password is incorrect" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "NIM or password is incorrect" });
    }

    // Pastikan JWT_SECRET sudah terisi di .env
    if (!process.env.JWT_SECRET) {
      return res
        .status(500)
        .json({ message: "JWT secret is not set in environment" });
    }

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });
    return res.status(200).json({ token });
  } catch (error) {
    console.error("Login error:", error);
    return res
      .status(500)
      .json({ message: "Server error", error: error.message });
  }
};

const logout = (req, res) => {
  // Implement logout functionality if needed (e.g., invalidate token)
  return res.status(200).json({ message: "Logged out successfully" });
};

export default {
  register,
  login,
  logout,
};
