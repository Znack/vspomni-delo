###
 Module dependencies.
###
express = require('express')
routes = require('./routes/index')
dust = require('dustjs-linkedin')
log = require('./utils/log')(module)
config = require('./config/index')
passport = require('./utils/passport')
HttpError = require('./error/index').HttpError
expressSession = require('express-session')
MongoStore = require('connect-mongo')(expressSession)
mongoose = require('./utils/mongoose')
sessionStore = require('./utils/sessionStore')
passport = require('passport');
cons = require('consolidate')
serveStatic = require('serve-static')

app = module.exports = express()

# Configuration
app.settings.env = config.get('env')
app.set('views', __dirname + '/templates')
app.engine('dust', cons.dust)
app.set('view engine', 'dust')
app.set('env', config.get('env'))
app.use(require('body-parser').json())
app.use(require('morgan')())
app.use(require('method-override')())
app.use(require('cookie-parser')())
app.use(expressSession({
  secret: config.get("session:secret")
  key: config.get("session:key")
  store: sessionStore
  cookie: {maxAge: 2592000000} # 30*24*60*60*1000 = 2592000000 = 30 days
}))
app.use(require('./middleware/sendHttpError'))
app.use(passport.initialize())
app.use(passport.session())
app.use(require('./middleware/passUserToLocals'))
routes(app)
app.use(serveStatic('public', {}))
app.use(require("./middleware/errorHandler"))

app.listen(config.get('port'), ()->
  log.info("Express server listening on port %d in %s mode", config.get('port'), config.get('env'))
)

process.on('uncaughtException',  (err)->
  log.error('uncaughtException:', err.message)
  log.error(err.stack)
  process.exit(1)
)