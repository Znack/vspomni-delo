config = require('config/index')

module.exports = (req, res, next) ->
  res.header('Access-Control-Allow-Origin', config.get('allowedDomains'))
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE')
  res.header('Access-Control-Allow-Credentials', true)
  res.header('Access-Control-Allow-Headers', 'Content-Type')

  next()