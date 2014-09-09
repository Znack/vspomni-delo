async = require('async')
mongoose = require('utils/mongoose')

Schema = mongoose.Schema
schema = new Schema({
  vkontakteId:
    type: String
    unique: true
    required: true
  displayName:
    type: String
    required: true
  created:
    type: Date
    "default": Date.now
})

schema.statics.findOrCreate = (userData, callback)->
  User = @
  async.waterfall([
    (callback)->
      User.findOne({vkontakteId: userData.vkontakteId}, callback)
    ,
    (user, callback)->
      if user
        return callback(null, user)
      else
        user = new User({vkontakteId: userData.vkontakteId, displayName: userData.displayName})
        user.save((err)->
          return callback(err) if err
          callback(null, user)
        )
  ],callback)

exports.User = mongoose.model('User', schema)

path = require('path')
http = require('http')

class AuthError extends Error
  constructor: (@message="Auth Error") ->
    Error.apply(@, arguments)
    Error.captureStackTrace(@, AuthError)

exports.AuthError = AuthError
