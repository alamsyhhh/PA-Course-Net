const wrapResponse = (status, message, data = null) => {
  return {
    status,
    message,
    data,
  };
};

const wrapResponse2 = (status, message) => {
  return {
    status,
    message,
  };
};

const handleSuccessResponse = (res, statusCode, message, data = null) => {
  res.status(statusCode).json(wrapResponse(statusCode, message, data));
};

const handleSuccessResponse2 = (res, statusCode, message) => {
  res.status(statusCode).json(wrapResponse2(statusCode, message));
};

const handleErrorResponse = (res, statusCode, message) => {
  res.status(statusCode).json(wrapResponse2(statusCode, message));
};

module.exports = {
  wrapResponse,
  handleSuccessResponse,
  handleSuccessResponse2,
  handleErrorResponse,
};
