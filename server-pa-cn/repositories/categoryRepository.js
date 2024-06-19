const { Categories } = require('../models');

class CategoryRepository {
  async findAll() {
    return await Categories.findAll();
  }
}

module.exports = new CategoryRepository();
