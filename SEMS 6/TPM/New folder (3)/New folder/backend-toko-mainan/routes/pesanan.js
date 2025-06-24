import express from "express";
import pesananController from "../controllers/pesananController.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

router.post("/", authMiddleware.verifyToken, pesananController.createOrder);
router.get("/", authMiddleware.verifyToken, pesananController.getUserOrders);
router.post("/pay", authMiddleware.verifyToken, pesananController.payOrder);

export default router;
