async = require('async')
mongoose = require('utils/mongoose')
User = require('models/user').User
ObjectId = mongoose.Types.ObjectId
HttpError = require('error/index').HttpError

Schema = mongoose.Schema
schema = new Schema({
  title:
    type: String
  author:
    type: Schema.ObjectId,
    ref: "User"
  deadLine:
    type: Date
  clientX:
    type: Number
    min: 0
    "default": 50
  clientY:
    type: Number
    min: 0
    "default": 50
  width:
    type: Number
    min: 125
    "default": 150
  removed:
    type: Boolean
    "default": false
})

schema.statics.create = (todoData, callback)->
  Todo = @
  todoData["author"] = todoData["author"]["_id"]
  todo = new Todo(todoData)
  todo.save(callback)

schema.statics.list = (user, callback)->
  @find({author: user["_id"], removed: false}, callback)

schema.statics.listOfRemoved = (user, callback)->
  @find({author: user["_id"], removed: true}, callback)

schema.statics.update = (todoData, callback)->
  todoId = ObjectId(todoData['_id'])
  delete todoData['_id']
  @findOneAndUpdate({"_id": todoId}, todoData, callback)

schema.statics.delete = (todoId, callback)->
  todoId = ObjectId(todoId)
  @findOneAndUpdate({"_id": todoId}, {$set: {removed: true}}, callback)

exports.Todo = mongoose.model('Todo', schema)

