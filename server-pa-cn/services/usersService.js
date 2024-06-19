const { UserRepository } = require('../repositories/userRepository');
const { generateToken, verifyToken } = require('../utils/jwtUtils');
const { uploadAvatarToCloudinary } = require('../middleware/upload');
const { hashPassword, comparePassword } = require('../utils/bcryptUtils');

class UserService {
  static async registerUser(username, password, avatarBuffer = null) {
    try {
      const existingUser = await UserRepository.findByUsername(username);
      if (existingUser) {
        throw new Error('Username already exists');
      }

      if (password.length < 8) {
        throw new Error('Password must be at least 8 characters long');
      }

      const hashedPassword = await hashPassword(password);

      let avatarPath = null;
      if (avatarBuffer) {
        console.log('Avatar buffer in service:', avatarBuffer);
        avatarPath = await uploadAvatarToCloudinary(avatarBuffer);
        console.log('Avatar path:', avatarPath);
      }

      const newUser = await UserRepository.create({
        username,
        password: hashedPassword,
        avatar_path: avatarPath,
      });

      console.log('New user created:', newUser);

      return newUser;
    } catch (error) {
      throw error;
    }
  }

  static async loginUser(username, password) {
    try {
      const user = await UserRepository.findByUsername(username);
      if (!user) {
        throw new Error('Invalid username or password');
      }

      const isPasswordValid = await comparePassword(password, user.password);
      if (!isPasswordValid) {
        throw new Error('Invalid username or password');
      }

      const token = generateToken(user);

      return { token, user };
    } catch (error) {
      throw error;
    }
  }

  static async getCurrentUserProfile(userId) {
    try {
      const user = await UserRepository.findById(userId);
      if (!user) {
        throw new Error('User not found');
      }
      return {
        username: user.username,
        avatarPath: user.avatar_path,
      };
    } catch (error) {
      throw error;
    }
  }
}

module.exports = UserService;
