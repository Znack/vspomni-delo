Todo = require('models/todo').Todo
HttpError = require('error/index').HttpError

exports.get = (req, res, next)->
  todos = []
  if req.user
    Todo.list(req.user, (err, todos)->
      return next(err) if err
      res.json(todos)
    )
  else
    next(new HttpError(403))

exports.listOfRemoved = (req, res, next)->
  todos = []
  if req.user
    Todo.listOfRemoved(req.user, (err, todos)->
      return next(err) if err
      res.json(todos)
    )
  else
    next(new HttpError(403))

exports.put = (req, res, next)->
  if req.user and req.body
    Todo.create({title: req.body.title, author: req.user, deadLine: req.body.deadLine}, (err, todo)->
      return next(err) if err
      return res.json(todo)
    )
  else
    res.json({status: 'error', err: "Invalid request"})

exports.post = (req, res, next)->
  if req.user and req.body["_id"] and req.params['todoId']
    Todo.update(req.body, (err, todo)->
      return next(err) if err
      return res.json(todo)
    )
  else
    res.json({status: 'error', err: "Invalid request"})

exports.delete = (req, res, next)->
  if req.user and req.params['todoId']
    Todo.delete(req.params['todoId'], (err, status)->
      return next(err) if err
      return res.json({status})
    )
  else
    return next(new HttpError(404))