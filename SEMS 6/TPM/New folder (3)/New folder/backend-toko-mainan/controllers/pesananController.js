// File: /backend-toko-mainan/backend-toko-mainan/controllers/pesananController.js

import { Pesanan, User, Mainan } from "../models/index.js";

const createOrder = async (req, res) => {
  try {
    const { mainanId, quantity } = req.body;
    const userId = req.user.id;

    const mainan = await Mainan.findByPk(mainanId);
    if (!mainan) {
      return res.status(404).json({ message: "Mainan not found" });
    }

    if (mainan.stock < quantity) {
      return res.status(400).json({ message: "Not enough stock available" });
    }

    const pesanan = await Pesanan.create({
      userId,
      mainanId,
      quantity,
      totalPrice: mainan.price * quantity,
      orderDate: new Date(),
    });

    mainan.stock -= quantity;
    await mainan.save();

    return res.status(201).json(pesanan);
  } catch (error) {
    return res.status(500).json({ message: "Error creating order", error });
  }
};

const getUserOrders = async (req, res) => {
  try {
    const userId = req.user.id;
    const orders = await Pesanan.findAll({
      where: { userId },
      include: [{ model: Mainan, as: 'Mainan' }], // gunakan alias 'Mainan' agar frontend bisa akses p['Mainan']
    });
    return res.status(200).json(orders);
  } catch (error) {
    return res.status(500).json({ message: "Error retrieving orders", error });
  }
};

// Melanjutkan ke pembayaran (ubah status menjadi 'paid')
const payOrder = async (req, res) => {
  try {
    const { pesananId } = req.body;
    const userId = req.user.id;
    const pesanan = await Pesanan.findOne({ where: { id: pesananId, userId } });
    if (!pesanan) {
      return res.status(404).json({ message: "Pesanan tidak ditemukan" });
    }
    if (pesanan.status === "paid") {
      return res.status(400).json({ message: "Pesanan sudah dibayar" });
    }
    pesanan.status = "paid";
    await pesanan.save();
    return res.json({ message: "Pembayaran berhasil", pesanan });
  } catch (error) {
    return res.status(500).json({ message: "Gagal memproses pembayaran", error });
  }
};

export default {
  createOrder,
  getUserOrders,
  payOrder,
};
