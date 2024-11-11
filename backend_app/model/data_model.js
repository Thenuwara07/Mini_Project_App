const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const toDoSchema = new Schema({
    userId:{
        type: String,
        // ref: UserModel.modelName
    },
    fullname: {
        type: String,
        required: true
    },
    mothername: {
        type: String,
        required: true
    },
    bestfriendname: {
        type: String,
        required: true
    },
    petname: {
        type: String,
        required: true
    },
    ownq: {
        type: String,
        required: true
    },
    owna: {
        type: String,
        required: true
    },

},{timestamps:true});

const ToDoModel = db.model('personaldata',toDoSchema);
module.exports = ToDoModel;