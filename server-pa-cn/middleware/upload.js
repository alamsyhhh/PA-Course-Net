const multer = require('multer');
const cloudinary = require('../config/cloudinary');

const storage = multer.memoryStorage();

const fileFilter = (req, file, cb) => {
  const allowedMimeTypes = [
    'image/bmp',
    'image/jpeg',
    'image/x-png',
    'image/png',
    'image/gif',
    'image/svg+xml',
    'image/webp',
    'image/apng',
    
    'image/img',
    'image/imgp',
  ];
  const res = req.res;
  if (allowedMimeTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    const error = res.status(400).json({
      status: 400,
      message: 'Hanya diperbolehkan untuk mengunggah file gambar (JPG, PNG)!',
    });
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
});

const uploadImageToCloudinary = (image) => {
  return new Promise((resolve, reject) => {
    cloudinary.uploader
      .upload_stream(
        { folder: 'pa-cn/products', resource_type: 'auto' },
        (error, result) => {
          if (result) {
            resolve(result.secure_url);
          } else {
            reject(error);
          }
        }
      )
      .end(image.buffer);
  });
};

const uploadAvatarToCloudinary = (buffer) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder: 'pa-cn/avatars', resource_type: 'auto' },
      (error, result) => {
        if (result) {
          console.log('Cloudinary upload result:', result);
          resolve(result.secure_url);
        } else {
          console.error('Cloudinary upload error:', error);
          reject(error);
        }
      }
    );
    stream.end(buffer);
  });
};

module.exports = { upload, uploadImageToCloudinary, uploadAvatarToCloudinary };
