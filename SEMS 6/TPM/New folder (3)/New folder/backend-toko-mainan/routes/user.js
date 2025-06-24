import express from "express";
import * as userController from "../controllers/userController.js";
import authMiddleware from "../middleware/authMiddleware.js";
import { uploadPhoto } from '../controllers/userController.js';
import { User } from '../models/index.js';

const router = express.Router();

router.get(
  "/profile",
  authMiddleware.verifyToken,
  userController.getUserProfile
);
router.put(
  "/profile",
  authMiddleware.verifyToken,
  userController.updateUserProfile
);
router.post('/upload-photo', authMiddleware.verifyToken, uploadPhoto);
router.get('/photo/:id', async (req, res) => {
  try {
    res.set('Access-Control-Allow-Origin', '*'); // CORS fix for web image
    console.log('Fetching photo for user ID:', req.params.id);
    
    const user = await User.findByPk(req.params.id);
    console.log('User found:', user ? 'Yes' : 'No');
    console.log('Photo blob exists:', user && user.photo_blob ? 'Yes' : 'No');
    
    if (!user) {
      console.log('User not found, returning 404');
      return res.status(404).json({ error: 'User not found' });
    }
    
    if (!user.photo_blob) {
      console.log('No photo blob found for user, returning default avatar');
      // Instead of 404, return a default avatar or placeholder
      return res.status(404).json({ error: 'Photo not found for this user' });
    }
    
    res.set('Content-Type', 'image/jpeg');
    res.send(user.photo_blob);
  } catch (error) {
    console.error('Error fetching photo:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
});

export default router;
