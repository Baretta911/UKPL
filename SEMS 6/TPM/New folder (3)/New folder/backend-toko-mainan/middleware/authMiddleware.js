import jwt from "jsonwebtoken";

export const verifyToken = (req, res, next) => {
  console.log('=== AUTH MIDDLEWARE ===', req.method, req.originalUrl);
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    console.log('No Authorization header');
    return res.status(401).json({ message: 'No token provided' });
  }
  // Ambil token dari header Authorization: Bearer <token>
  const token = authHeader.startsWith("Bearer ")
    ? authHeader.split(" ")[1]
    : authHeader;

  if (!token) {
    return res.status(403).json({ message: "No token provided!" });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Unauthorized!" });
    }
    req.user = decoded;
    next();
  });
};

export default { verifyToken };
