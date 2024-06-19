const categoriesRoute = require('express').Router();
const { CategoriesController } = require('../controllers');
const authenticateToken = require('../middleware/auth');

categoriesRoute.get(
  '/',
  authenticateToken,
  CategoriesController.getAllCategories
);

module.exports = categoriesRoute;
