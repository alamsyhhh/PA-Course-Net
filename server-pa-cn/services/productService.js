const productRepository = require('../repositories/productRepository');
const { uploadImageToCloudinary } = require('../middleware/upload');

class ProductService {
  async getAllProducts(categoryId, name) {
    return await productRepository.findAll(categoryId, name);
  }

  async getProductById(id) {
    const product = await productRepository.findById(id);
    if (!product) {
      throw new Error('Product not found');
    }
    return product;
  }

  async createProduct(data, image, user) {
    const imageUrl = await uploadImageToCloudinary(image);

    const productData = {
      ...data,
      imageUrl,
      createdBy: user.username,
      updatedBy: user.username,
    };

    const product = await productRepository.create(productData);

    return {
      id: product.id,
      name: product.name,
      qty: product.qty,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      createdBy: product.createdBy,
      updatedBy: product.updatedBy,
    };
  }

  async updateProduct(id, data, image, user) {
    const product = await productRepository.findById(id);
    if (!product) {
      throw new Error('Product not found');
    }

    if (image) {
      const imageUrl = await uploadImageToCloudinary(image);
      data.imageUrl = imageUrl;
    }

    data.updatedBy = user.username;

    return await productRepository.update(product, data);
  }

  async deleteProduct(id) {
    const product = await productRepository.findById(id);
    if (!product) {
      throw new Error('Product not found');
    }
    return await productRepository.delete(product);
  }
}

module.exports = new ProductService();
