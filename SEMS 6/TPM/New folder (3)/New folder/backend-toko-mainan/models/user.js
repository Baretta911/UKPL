// File: /backend-toko-mainan/backend-toko-mainan/models/user.js

const user = (sequelize, DataTypes) => {
  const User = sequelize.define("User", {
    nim: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    // photo: { type: DataTypes.STRING, allowNull: true }, // legacy, hapus jika frontend tidak pakai
    photo_blob: {
      type: DataTypes.BLOB('long'),
      allowNull: true,
    },
  });

  User.associate = (models) => {
    User.hasMany(models.Pesanan, {
      foreignKey: "userId",
      as: "pesanan",
    });
  };

  return User;
};

export default user;
