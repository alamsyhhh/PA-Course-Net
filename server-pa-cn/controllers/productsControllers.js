const productService = require('../services/productService');
const {
  handleSuccessResponse,
  handleSuccessResponse2,
  handleErrorResponse,
} = require('../utils/responseHelper');

exports.getAllProducts = async (req, res) => {
  try {
    const { categoryId, name } = req.query; // Ambil categoryId dan name dari query parameters
    const products = await productService.getAllProducts(categoryId, name);
    handleSuccessResponse(res, 200, 'Products fetched successfully', products);
  } catch (error) {
    handleErrorResponse(res, 500, error.message);
  }
};

exports.getProductById = async (req, res) => {
  try {
    const product = await productService.getProductById(req.params.id);
    handleSuccessResponse(res, 200, 'Product fetched successfully', product);
  } catch (error) {
    if (error.message === 'Product not found') {
      handleErrorResponse(res, 404, error.message);
    } else {
      handleErrorResponse(res, 500, error.message);
    }
  }
};

exports.createProduct = async (req, res) => {
  try {
    const product = await productService.createProduct(
      req.body,
      req.file,
      req.user
    );

    handleSuccessResponse(res, 201, 'Product created successfully', product);
  } catch (error) {
    handleErrorResponse(res, 500, error.message);
  }
};

exports.updateProduct = async (req, res) => {
  try {
    const product = await productService.updateProduct(
      req.params.id,
      req.body,
      req.file,
      req.user
    );
    handleSuccessResponse(res, 200, 'Product updated successfully', product);
  } catch (error) {
    if (error.message === 'Product not found') {
      handleErrorResponse(res, 404, error.message);
    } else {
      handleErrorResponse(res, 500, error.message);
    }
  }
};

exports.deleteProduct = async (req, res) => {
  try {
    await productService.deleteProduct(req.params.id);
    handleSuccessResponse2(res, 200, 'Product deleted successfully');
  } catch (error) {
    if (error.message === 'Product not found') {
      handleErrorResponse(res, 404, error.message);
    } else {
      handleErrorResponse(res, 500, error.message);
    }
  }
};
