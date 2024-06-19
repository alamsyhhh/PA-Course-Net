const categoryService = require('../services/categoryService');
const {
  handleSuccessResponse,
  handleErrorResponse,
} = require('../utils/responseHelper');

exports.getAllCategories = async (req, res) => {
  try {
    const categories = await categoryService.getAllCategories();
    handleSuccessResponse(
      res,
      200,
      'Categories fetched successfully',
      categories
    );
  } catch (error) {
    handleErrorResponse(res, 500, error.message);
  }
};
