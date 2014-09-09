config = require('config/index')
passport = require('passport');
AuthVKStrategy = require('passport-vkontakte').Strategy;
User = require('models/user').User

passport.use(new AuthVKStrategy({
  clientID:     config.get('passport:vkontakteAppId'), # VK.com docs call it 'API ID'
  clientSecret: config.get('passport:vkontakteAppSecret'),
  callbackURL:  "#{config.get('domain')}auth/vkontakte/callback"
},
(accessToken, refreshToken, profile, done) ->
  User.findOrCreate({ vkontakteId: profile.id, displayName: profile.displayName }, (err, user)->
    return done(err, user)
  )
))

passport.serializeUser((user, done)->
  done(null, user)
)

passport.deserializeUser((user, done)->
  done(null, user)
)

module.exports = (app) ->
