import express from "express";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import { sequelize } from "./models/index.js";
import cors from "cors"; // tambahkan ini
import router from "./routes/index.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Configure CORS to handle file uploads properly
app.use(cors({
  origin: '*',  // In production, specify your frontend URL
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ extended: true, limit: '10mb' }));
app.use('/uploads', express.static('uploads'));

// API routes
app.get("/", (req, res) => {
  res.send("Toko Mainan API is running");
});
app.use("/api", router);

// Sinkronisasi database sebelum listen
console.log("Mulai sync database...");
sequelize
  .sync({ alter: true })
  .then(() => {
    console.log("Sync database selesai, listen...");
    app.listen(PORT, "0.0.0.0", () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error("Database sync error:", err);
  });
