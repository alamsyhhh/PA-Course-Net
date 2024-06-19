require('dotenv').config();
const express = require('express');
const app = express();
const port = process.env.PORT || 9000;

const routes = require('./routes');
const errorHandler = require('./middleware/errorHandler');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(routes);

app.use(errorHandler);

app.listen(port, () => {
  console.log(`App is listening on ${port}`);
});
