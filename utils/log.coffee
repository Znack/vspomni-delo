winston = require('winston')
config = require('config/index')
env = config.get('env')

getLogger = (module) ->
  path = module.filename.split('/').slice(-2).join('/');
  logger = new winston.Logger({
    transports: [
      new winston.transports.Console({
        colorize: true,
        level: if env == 'development' then 'debug' else 'error',
        label: path
      })
    ]
  })
  if env == 'production'
    logger.add(winston.transports.File, {
      filename: 'logs/debug.log',
      handleExceptions: true,
      level: 'debug',
      label: path
    })
  return logger

module.exports = getLogger;