const app = require("./app");
const db = require('./config/db')
const ToDoModel = require('./model/data_model');


const fs = require('fs')
const https = require('https')
const port = process.env.PORT || 3000;

app.get("/",(req,res)=>{
    res.send("Hello World111");
})

app.listen(port,()=>{
    console.log(`Server Listening on Port http://localhost:${port}`);
})
