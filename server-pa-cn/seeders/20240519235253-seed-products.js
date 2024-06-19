'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('products', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE products_id_seq RESTART WITH 1'
    );

    await queryInterface.bulkInsert(
      'products',
      [
        {
          name: 'Laptop',
          qty: 10,
          categoryId: 1,
          imageUrl:
            'https://res.cloudinary.com/dmuuypm2t/image/upload/v1710400118/img_car_lhk3me.png',
          createdAt: new Date(),
          updatedAt: new Date(),
          createdBy: 'admin',
          updatedBy: 'admin',
        },
        {
          name: 'Book Title',
          qty: 50,
          categoryId: 2,
          imageUrl:
            'https://res.cloudinary.com/dmuuypm2t/image/upload/v1710400118/img_car_lhk3me.png',
          createdAt: new Date(),
          updatedAt: new Date(),
          createdBy: 'admin',
          updatedBy: 'admin',
        },
      ],
      {}
    );
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('products', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE products_id_seq RESTART WITH 1'
    );
  },
};
