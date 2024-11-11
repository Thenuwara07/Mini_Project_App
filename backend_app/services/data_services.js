
const { deleteToDo } = require("../controller/data_controller");
const ToDoModel = require("../model/data_model");

class ToDoService{
    static async createToDo(userId,fullname, mothername, bestfriendname, petname, ownq, owna){
            const createToDo = new ToDoModel({userId,fullname, mothername, bestfriendname, petname, ownq, owna});
            return await createToDo.save();
    }

    static async getUserToDoList(userId){
        const todoList = await ToDoModel.find({userId})
        return todoList;
    }

   static async deleteToDo(id){
        const deleted = await ToDoModel.findByIdAndDelete({_id:id})
        return deleted;
   }
}

module.exports = ToDoService;