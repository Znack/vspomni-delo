path = require('path')
http = require('http')

class HttpError extends Error
  constructor: (@status, @message=http.STATUS_CODES[status] || "Error") ->
    Error.apply(@, arguments)
    Error.captureStackTrace(@, HttpError)

exports.HttpError = HttpError
