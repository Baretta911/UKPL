// backend-toko-mainan/controllers/userController.js

import { User } from "../models/index.js";
import multer from "multer";

// Use only memory storage for multer
const upload = multer({ 
  storage: multer.memoryStorage(),
  fileFilter: (req, file, cb) => {
    console.log('=== FILE FILTER ===');
    console.log('File mimetype:', file.mimetype);
    console.log('File originalname:', file.originalname);
    console.log('File fieldname:', file.fieldname);
    console.log('File size:', file.size);
    
    // Hanya izinkan file gambar
    if (!file.mimetype.startsWith('image/')) {
      console.log('Rejected file - not an image:', file.mimetype);
      return cb(new Error('File harus berupa gambar!'), false);
    }
    console.log('File accepted as image');
    cb(null, true);
  },
  limits: { fileSize: 2 * 1024 * 1024 }, // Maksimal 2MB
});

// Function to get user profile
const getUserProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    
    console.log(`User ${userId} found, photo_blob exists: ${user.photo_blob ? 'Yes' : 'No'}`);
    
    res.status(200).json({
      id: user.id,
      nim: user.nim,
      name: user.name,
      email: user.email,
      photo: user.photo_blob ? `${req.protocol}://${req.get('host')}/api/user/photo/${user.id}` : null,
    });
  } catch (error) {
    console.error('Error in getUserProfile:', error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Function to update user profile (name/email only)
const updateUserProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    let { name, email } = req.body;
    const user = await User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    user.name = name || user.name;
    user.email = email || user.email;
    await user.save();
    res.status(200).json({ message: "Profile updated successfully", user: {
      id: user.id,
      nim: user.nim,
      name: user.name,
      email: user.email,
      photo: user.photo_blob ? `${req.protocol}://${req.get('host')}/api/user/photo/${user.id}` : '',
    }});
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Handler upload photo (save to BLOB only)
const uploadPhoto = [
  upload.single("photo"),
  async (req, res) => {
    try {
      console.log('Upload photo request received');
      console.log('User from token:', req.user);
      console.log('File info:', req.file ? { 
        originalname: req.file.originalname, 
        mimetype: req.file.mimetype, 
        size: req.file.size 
      } : 'No file');
      
      const userId = req.user?.id || req.body.userId;
      console.log('User ID:', userId);
      
      if (!userId) {
        return res.status(400).json({ message: "User ID required" });
      }
      
      if (!req.file) {
        return res.status(400).json({ message: "No file uploaded" });
      }
      
      const user = await User.findByPk(userId);
      console.log('User found in database:', user ? 'Yes' : 'No');
      
      if (!user) {
        return res.status(404).json({ message: "User not found" });
      }
      
      user.photo_blob = req.file.buffer;
      await user.save();
      console.log('Photo saved successfully');
      
      res.json({ message: "Photo uploaded", user: {
        id: user.id,
        nim: user.nim,
        name: user.name,
        email: user.email,
        photo: `${req.protocol}://${req.get('host')}/api/user/photo/${user.id}`,
      }});
    } catch (err) {
      console.error('Upload photo error:', err);
      res.status(500).json({ message: "Upload failed", error: err.message });
    }
  },
];

export { getUserProfile, updateUserProfile, uploadPhoto };
