const jwt = require('jsonwebtoken');
const { handleErrorResponse } = require('../utils/responseHelper');
const jwtSecret = process.env.JWT_SECRET || 'your_jwt_secret';

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) {
    return handleErrorResponse(res, 401, 'Token not provided');
  }

  jwt.verify(token, jwtSecret, (err, user) => {
    if (err) {
      return handleErrorResponse(res, 403, 'Invalid token');
    }
    req.user = user;
    next();
  });
};

module.exports = authenticateToken;
