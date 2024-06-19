const { Users } = require('../models');

class UserRepository {
  static async findByUsername(username) {
    return await Users.findOne({ where: { username } });
  }

  static async create(user) {
    return await Users.create(user);
  }

  static async findById(id) {
    return await Users.findByPk(id);
  }
}

module.exports = { UserRepository };
