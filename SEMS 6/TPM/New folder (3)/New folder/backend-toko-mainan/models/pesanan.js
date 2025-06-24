const pesanan = (sequelize, DataTypes) => {
  const Pesanan = sequelize.define("Pesanan", {
    orderDate: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
    totalPrice: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    quantity: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: "pending", // pending, paid, cancelled
    },
  });

  Pesanan.associate = (models) => {
    Pesanan.belongsTo(models.User, {
      foreignKey: "userId",
      as: "user",
    });
    Pesanan.belongsTo(models.Mainan, {
      foreignKey: "mainanId",
      as: "mainan",
    });
  };

  return Pesanan;
};

export default pesanan;
