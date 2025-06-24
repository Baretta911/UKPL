import express from "express";
import authRoutes from "./auth.js";
import mainanRoutes from "./mainan.js";
import pesananRoutes from "./pesanan.js";
import userRoutes from "./user.js";

const router = express.Router();

router.use("/auth", authRoutes);
router.use("/mainan", mainanRoutes);
router.use("/pesanan", pesananRoutes);
router.use("/user", userRoutes);

export default router;
