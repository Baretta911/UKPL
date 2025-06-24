import { Mainan, Pesanan } from "../models/index.js";
import { Op, fn, col, where } from "sequelize";
import multer from "multer";

const uploadMainan = multer({ storage: multer.memoryStorage() });

// Endpoint upload gambar mainan
const uploadMainanImage = [
  uploadMainan.single("image"),
  async (req, res) => {
    try {
      if (!req.file) return res.status(400).json({ message: "No file uploaded" });
      const mainanId = req.body.id;
      if (!mainanId) return res.status(400).json({ message: "Mainan ID required" });
      const mainan = await Mainan.findByPk(mainanId);
      if (!mainan) return res.status(404).json({ message: "Mainan not found" });
      mainan.image_blob = req.file.buffer;
      await mainan.save();
      res.status(200).json({ message: "Image uploaded", mainan });
    } catch (err) {
      res.status(500).json({ message: "Upload failed", error: err.message });
    }
  },
];

const getAllMainan = async (req, res) => {
  try {
    const mainan = await Mainan.findAll();
    res.status(200).json(mainan);
  } catch (error) {
    res.status(500).json({ message: "Error retrieving toys", error });
  }
};

const getMainanById = async (req, res) => {
  const { id } = req.params;
  try {
    const mainan = await Mainan.findByPk(id);
    if (!mainan) {
      return res.status(404).json({ message: "Toy not found" });
    }
    res.status(200).json(mainan);
  } catch (error) {
    res.status(500).json({ message: "Error retrieving toy", error });
  }
};

const orderMainan = async (req, res) => {
  const { id, quantity } = req.body;
  try {
    // Tambahkan pengecekan user login
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "Unauthorized" });
    }
    const mainan = await Mainan.findByPk(id);
    if (!mainan) {
      return res.status(404).json({ message: "Toy not found" });
    }
    if (mainan.stock < quantity) {
      return res.status(400).json({ message: "Not enough stock available" });
    }
    mainan.stock -= quantity;
    await mainan.save();

    const totalPrice = Number(mainan.price) * Number(quantity);

    // Simpan ke tabel Pesanan
    const pesanan = await Pesanan.create({
      userId: req.user.id,
      mainanId: mainan.id,
      quantity,
      totalPrice,
      orderDate: new Date(),
    });

    res.status(200).json({
      message: "Order successful",
      mainan,
      pesanan,
    });
  } catch (error) {
    res.status(500).json({ message: "Error ordering toy", error });
  }
};

const searchMainan = async (req, res) => {
  const { name } = req.query;
  try {
    if (!name) {
      return res.status(400).json({ message: "Parameter 'name' is required" });
    }
    // Case-insensitive search (agar bisa di semua DB)
    const mainans = await Mainan.findAll({
      where: {
        name: {
          [Op.like]: `%${name}%`,
        },
      },
    });
    // Jika hasil kosong, coba pakai lower-case fallback (untuk DB yang case-sensitive)
    if (mainans.length === 0) {
      const mainansLower = await Mainan.findAll({
        where: where(fn("LOWER", col("name")), {
          [Op.like]: `%${name.toLowerCase()}%`,
        }),
      });
      return res.status(200).json(mainansLower);
    }
    res.status(200).json(mainans);
  } catch (error) {
    res.status(500).json({ message: "Error searching toys", error });
  }
};

const refreshMainan = async (req, res) => {
  try {
    const mainan = await Mainan.findAll();
    res.status(200).json(mainan);
  } catch (error) {
    res.status(500).json({ message: "Error refreshing toys", error });
  }
};

// Tambahkan endpoint konversi harga mainan ke beberapa mata uang
const convertMainanPrices = async (req, res) => {
  // Kurs statis, bisa diganti dengan API jika mau dinamis
  const rates = {
    USD: 15500,
    EUR: 17000,
    JPY: 110,
  };
  try {
    const mainan = await Mainan.findAll();
    const result = mainan.map((m) => {
      const price = Number(m.price);
      return {
        id: m.id,
        name: m.name,
        stock: m.stock,
        price_rupiah: price,
        price_usd: +(price / rates.USD).toFixed(2),
        price_eur: +(price / rates.EUR).toFixed(2),
        price_jpy: Math.round(price / rates.JPY),
      };
    });
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ message: "Error converting prices", error });
  }
};

// Endpoint tambah mainan
const createMainan = async (req, res) => {
  try {
    console.log('=== POST /mainan ===');
    console.log('req.body:', req.body);
    console.log('req.file:', req.file);
    let { name, price, stock, imgUrl } = req.body;
    let image_blob = null;
    if (req.file) {
      // Simpan buffer ke image_blob
      image_blob = req.file.buffer;
    }
    const mainan = await Mainan.create({ name, price, stock, imgUrl, image_blob });
    console.log('Mainan berhasil dibuat:', mainan?.id);
    res.status(201).json(mainan);
  } catch (error) {
    console.error('POST /mainan error:', error);
    res.status(500).json({ message: "Error creating toy", error });
  }
};

// Edit mainan
const updateMainan = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, price, stock, imgUrl } = req.body;
    const mainan = await Mainan.findByPk(id);
    if (!mainan) return res.status(404).json({ message: "Toy not found" });
    await mainan.update({ name, description, price, stock, imgUrl });
    res.status(200).json(mainan);
  } catch (error) {
    res.status(500).json({ message: "Error updating toy", error });
  }
};

// Hapus mainan
const deleteMainan = async (req, res) => {
  try {
    const { id } = req.params;
    const mainan = await Mainan.findByPk(id);
    if (!mainan) return res.status(404).json({ message: "Toy not found" });
    await mainan.destroy();
    res.status(204).end();
  } catch (error) {
    res.status(500).json({ message: "Error deleting toy", error });
  }
};

export default {
  getAllMainan,
  getMainanById,
  orderMainan,
  searchMainan,
  refreshMainan,
  convertMainanPrices,
  createMainan,
  updateMainan,
  deleteMainan,
};

export { uploadMainanImage };
