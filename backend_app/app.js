
const express = require("express");
const bodyParser = require("body-parser")

const cors = require("cors");
// const UserRoute = require("./routes/user.routes");
const ToDoRoute = require('./routers/data_routes');
const app = express();
app.use(bodyParser.json())
app.use(cors());
// app.use("/",UserRoute);
app.use("/",ToDoRoute);
module.exports = app;



