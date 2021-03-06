// Generated by CoffeeScript 1.6.3
(function() {
  var HttpError, ObjectId, Schema, User, async, mongoose, schema;

  async = require('async');

  mongoose = require('utils/mongoose');

  User = require('models/user').User;

  ObjectId = mongoose.Types.ObjectId;

  HttpError = require('error/index').HttpError;

  Schema = mongoose.Schema;

  schema = new Schema({
    title: {
      type: String
    },
    author: {
      type: Schema.ObjectId,
      ref: "User"
    },
    deadLine: {
      type: Date
    },
    clientX: {
      type: Number,
      min: 0,
      "default": 50
    },
    clientY: {
      type: Number,
      min: 0,
      "default": 50
    },
    width: {
      type: Number,
      min: 125,
      "default": 150
    },
    removed: {
      type: Boolean,
      "default": false
    }
  });

  schema.statics.create = function(todoData, callback) {
    var Todo, todo;
    Todo = this;
    todoData["author"] = todoData["author"]["_id"];
    todo = new Todo(todoData);
    return todo.save(callback);
  };

  schema.statics.list = function(user, callback) {
    return this.find({
      author: user["_id"],
      removed: false
    }, callback);
  };

  schema.statics.listOfRemoved = function(user, callback) {
    return this.find({
      author: user["_id"],
      removed: true
    }, callback);
  };

  schema.statics.update = function(todoData, callback) {
    var todoId;
    todoId = ObjectId(todoData['_id']);
    delete todoData['_id'];
    return this.findOneAndUpdate({
      "_id": todoId
    }, todoData, callback);
  };

  schema.statics["delete"] = function(todoId, callback) {
    todoId = ObjectId(todoId);
    return this.findOneAndUpdate({
      "_id": todoId
    }, {
      $set: {
        removed: true
      }
    }, callback);
  };

  exports.Todo = mongoose.model('Todo', schema);

}).call(this);

/*
//@ sourceMappingURL=todo.map
*/
