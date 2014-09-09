// Generated by CoffeeScript 1.6.3
(function() {
  var AuthVKStrategy, User, config, passport;

  config = require('config/index');

  passport = require('passport');

  AuthVKStrategy = require('passport-vkontakte').Strategy;

  User = require('models/user').User;

  passport.use(new AuthVKStrategy({
    clientID: config.get('passport:vkontakteAppId'),
    clientSecret: config.get('passport:vkontakteAppSecret'),
    callbackURL: "" + (config.get('domain')) + "auth/vkontakte/callback"
  }, function(accessToken, refreshToken, profile, done) {
    return User.findOrCreate({
      vkontakteId: profile.id,
      displayName: profile.displayName
    }, function(err, user) {
      return done(err, user);
    });
  }));

  passport.serializeUser(function(user, done) {
    return done(null, user);
  });

  passport.deserializeUser(function(user, done) {
    return done(null, user);
  });

  module.exports = function(app) {};

}).call(this);

/*
//@ sourceMappingURL=passport.map
*/