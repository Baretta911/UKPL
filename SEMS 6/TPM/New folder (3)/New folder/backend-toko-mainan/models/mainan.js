const mainan = (sequelize, DataTypes) => {
  const Mainan = sequelize.define("Mainan", {
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    price: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false,
    },
    stock: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },
    image_blob: {
      type: DataTypes.BLOB('long'),
      allowNull: true,
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: sequelize.literal('CURRENT_TIMESTAMP'),
    },
  });

  Mainan.associate = (models) => {
    Mainan.hasMany(models.Pesanan, {
      foreignKey: "mainanId",
      as: "pesanan",
    });
  };

  return Mainan;
};

export default mainan;
