mongoose = require('utils/mongoose')
expressSession = require('express-session')
MongoStore = require('connect-mongo')(expressSession)

module.exports = new MongoStore({mongoose_connection: mongoose.connection })
