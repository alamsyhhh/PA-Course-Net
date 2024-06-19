'use strict';
const { hashPassword } = require('../utils/bcryptUtils');

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('users', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE users_id_seq RESTART WITH 1'
    );

    const hashedPassword1 = await hashPassword('password123');
    const hashedPassword2 = await hashPassword('password456');

    await queryInterface.bulkInsert(
      'users',
      [
        {
          username: 'admin1',
          password: hashedPassword1,
          avatar_path:
            'https://res.cloudinary.com/dmuuypm2t/image/upload/v1710400255/img_photo1_clcavj.png',
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        {
          username: 'admin2',
          password: hashedPassword2,
          avatar_path:
            'https://res.cloudinary.com/dmuuypm2t/image/upload/v1710400256/img_photo2_s4csws.png',
          createdAt: new Date(),
          updatedAt: new Date(),
        },
      ],
      {}
    );
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('users', null, {});
    await queryInterface.sequelize.query(
      'ALTER SEQUENCE users_id_seq RESTART WITH 1'
    );
  },
};
