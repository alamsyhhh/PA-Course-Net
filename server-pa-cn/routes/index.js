const route = require('express').Router();

route.get('/', (req, res) => {
  res.json({
    message: 'Home Page',
  });
});

const categoriesRoutes = require('./categoriesRoutes');
const productsRoutes = require('./productsRoutes');
const usersRoutes = require('./usersRoutes');

route.use('/categories', categoriesRoutes);
route.use('/products', productsRoutes);
route.use('/users', usersRoutes);

module.exports = route;
