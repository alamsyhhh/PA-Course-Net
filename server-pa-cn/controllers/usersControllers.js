const UserService = require('../services/usersService');
const {
  handleSuccessResponse,
  handleSuccessResponse2,
  handleErrorResponse,
} = require('../utils/responseHelper');
const UserDto = require('../dto/userDto');

class UserController {
  static async registerUser(req, res) {
    const { username, password } = req.body;

    try {
      const avatarBuffer = req.file ? req.file.buffer : null;
      console.log('Avatar buffer:', avatarBuffer);
      const newUser = await UserService.registerUser(
        username,
        password,
        avatarBuffer
      );
      handleSuccessResponse2(res, 201, 'User registered successfully');
    } catch (error) {
      handleErrorResponse(res, 400, error.message);
    }
  }

  static async loginUser(req, res) {
    const { username, password } = req.body;

    try {
      const { token, user } = await UserService.loginUser(username, password);
      const userDto = new UserDto(user, token);
      handleSuccessResponse(res, 200, 'User logged in successfully', userDto);
    } catch (error) {
      handleErrorResponse(res, 400, error.message);
    }
  }

  static async getCurrentUserProfile(req, res) {
    try {
      const userId = req.user.id;
      const userProfile = await UserService.getCurrentUserProfile(userId);
      handleSuccessResponse(
        res,
        200,
        'User profile retrieved successfully',
        userProfile
      );
    } catch (error) {
      handleErrorResponse(res, 400, error.message);
    }
  }
}

module.exports = UserController;
