const { Products, Categories } = require('../models');

class ProductRepository {
  async findAll(categoryId, name) {
    const query = {
      include: [
        {
          model: Categories,
          as: 'category',
          attributes: ['name'],
        },
      ],
      order: [['createdAt', 'DESC']],
    };

    if (categoryId) {
      query.where = { categoryId };
    }

    if (name) {
      query.where = { ...query.where, name };
    }

    const products = await Products.findAll(query);

    return products.map((product) => {
      const productData = product.get({ plain: true });
      productData.categoryName = productData.category.name;
      delete productData.category;
      return productData;
    });
  }

  async findById(id) {
    return await Products.findByPk(id, {
      include: [
        {
          model: Categories,
          as: 'category',
          attributes: ['name'],
        },
      ],
    });
  }

  async create(data) {
    return await Products.create(data);
  }

  async update(product, data) {
    return await product.update(data);
  }

  async delete(product) {
    return await product.destroy();
  }
}

module.exports = new ProductRepository();
