const productsRoute = require('express').Router();
const { ProductsController } = require('../controllers');
const { upload } = require('../middleware/upload');
const authenticateToken = require('../middleware/auth');

productsRoute.get('/', authenticateToken, ProductsController.getAllProducts);
productsRoute.get('/:id', authenticateToken, ProductsController.getProductById);
productsRoute.post(
  '/',
  authenticateToken,
  upload.single('image'),
  ProductsController.createProduct
);
productsRoute.put(
  '/:id',
  authenticateToken,
  upload.single('image'),
  ProductsController.updateProduct
);
productsRoute.delete(
  '/:id',
  authenticateToken,
  ProductsController.deleteProduct
);

module.exports = productsRoute;
