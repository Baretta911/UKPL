import sequelize from "../config/database.js";
import { DataTypes } from "sequelize";

const userModel = (await import("./user.js")).default;
const mainanModel = (await import("./mainan.js")).default;
const pesananModel = (await import("./pesanan.js")).default;

const User = userModel(sequelize, DataTypes);
const Mainan = mainanModel(sequelize, DataTypes);
const Pesanan = pesananModel(sequelize, DataTypes);

// Relasi User dan Pesanan
User.hasMany(Pesanan, { foreignKey: "userId" });
Pesanan.belongsTo(User, { foreignKey: "userId" });

// Relasi Mainan dan Pesanan
Mainan.hasMany(Pesanan, { foreignKey: "mainanId" });
Pesanan.belongsTo(Mainan, { foreignKey: "mainanId" });

export { sequelize, User, Mainan, Pesanan };
export default { User, Mainan, Pesanan };
