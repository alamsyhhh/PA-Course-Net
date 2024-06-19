const usersRoute = require('express').Router();
const UserController = require('../controllers/usersControllers');
const { upload } = require('../middleware/upload');
const authenticateToken = require('../middleware/auth');

usersRoute.post(
  '/register',
  upload.single('avatar'),
  UserController.registerUser
);
usersRoute.post('/login', upload.none(), UserController.loginUser);

usersRoute.get(
  '/current-user',
  authenticateToken,
  UserController.getCurrentUserProfile
);

module.exports = usersRoute;
