import express from "express";
import mainanController, { uploadMainanImage } from "../controllers/mainanController.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

router.get("/", mainanController.getAllMainan);
// Endpoint search mainan by name (letakkan sebelum :id)
router.get("/search", mainanController.searchMainan);
router.get("/refresh", mainanController.refreshMainan);
router.get("/konversi/harga", mainanController.convertMainanPrices);
router.get("/:id", mainanController.getMainanById);
router.post("/order", authMiddleware.verifyToken, mainanController.orderMainan);
router.post("/upload-image", (req, res, next) => {
  uploadMainanImage[0](req, res, function (err) {
    if (err) {
      console.error("[UPLOAD MAINAN ERROR]", err);
      return res.status(500).json({ message: "Upload failed", error: err.message });
    }
    uploadMainanImage[1](req, res, next);
  });
});
router.post(
  "/",
  authMiddleware.verifyToken,
  (req, res, next) => {
    uploadMainanImage[0](req, res, function (err) {
      if (err) {
        // Jika error karena tidak ada file, lanjutkan ke createMainan
        if (err.message === "No file uploaded" || err.code === "LIMIT_UNEXPECTED_FILE") {
          return mainanController.createMainan(req, res, next);
        }
        console.error("[UPLOAD MAINAN ERROR]", err);
        return res.status(500).json({ message: "Upload failed", error: err.message });
      }
      // Jika tidak error, lanjut ke createMainan
      mainanController.createMainan(req, res, next);
    });
  }
);
router.put("/:id", authMiddleware.verifyToken, mainanController.updateMainan);
router.delete("/:id", authMiddleware.verifyToken, mainanController.deleteMainan);
router.get('/image/:id', async (req, res) => {
  const { Mainan } = await import('../models/index.js');
  const mainan = await Mainan.findByPk(req.params.id);
  if (!mainan || !mainan.image_blob) return res.status(404).send('Not found');
  res.set('Content-Type', 'image/jpeg');
  res.set('Access-Control-Allow-Origin', '*');
  res.send(mainan.image_blob);
});

export default router;
