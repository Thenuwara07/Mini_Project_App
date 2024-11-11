const mongoose = require('mongoose');
require("dotenv").config();

const url = `${process.env.MONGO_URL}?retryWrites=true&w=majority`;

const URL = process.env.MONGO_URL;
// mongoose.connect(URL, {
//   //useCreateIndex:true,
//   useNewUrlParser: true,
//   useUnifiedTopology: true,
//   //useFindAndModify:false
// });
// const connection = mongoose.connection;
// connection.once("open", () => {
//   console.log("MongoDB Connection Success!");
// });

const connection = mongoose.createConnection(URL).on('open',()=>{console.log("MongoDB Connected");}).on('error',()=>{
  console.log("MongoDB Connection error");
});
module.exports = connection;
