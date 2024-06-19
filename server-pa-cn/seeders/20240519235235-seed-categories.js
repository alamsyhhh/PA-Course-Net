'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('products', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE products_id_seq RESTART WITH 1'
    );

    await queryInterface.bulkDelete('categories', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE categories_id_seq RESTART WITH 1'
    );

    await queryInterface.bulkInsert(
      'categories',
      [
        {
          name: 'Electronics',
        },
        {
          name: 'Books',
        },
        {
          name: 'Clothing',
        },
        {
          name: 'Sports',
        },
        {
          name: 'Home & Kitchen',
        },
        {
          name: 'Beauty & Personal Care',
        },
        {
          name: 'Toys & Games',
        },
        {
          name: 'Automotive',
        },
        {
          name: 'Health & Household',
        },
      ],
      {}
    );
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('categories', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE categories_id_seq RESTART WITH 1'
    );
  },
};
