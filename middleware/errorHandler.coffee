express = require('express')
log = require('utils/log')(module)
HttpError = require('error/index').HttpError
config = require('config/index')
errorhandler = require('errorhandler')()

module.exports = (err, req, res, next)->
  if typeof err == 'number'
    err = new HttpError(err)
  if err instanceof HttpError
    res.sendHttpError(err);
  else
    if (config.get('env') == 'development')
      return errorhandler(err, req, res, next)
    else
      log.error(err.message)
      err = new HttpError(500)
      res.sendHttpError(err)


