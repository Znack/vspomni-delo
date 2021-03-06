// Generated by CoffeeScript 1.6.3
(function() {
  var allowCrossDomain, isLoggedIn, passport, todosRoutes;

  passport = require('passport');

  todosRoutes = require('./todos');

  isLoggedIn = require('middleware/isLoggedIn');

  allowCrossDomain = require('middleware/allowCrossDomain');

  module.exports = function(app) {
    app.get('/', require('./frontpage').get);
    app.get('/cabinet', require('./cabinet').get);
    app.get('/todos', isLoggedIn, allowCrossDomain, todosRoutes.get);
    app.get('/todos/removed', isLoggedIn, allowCrossDomain, todosRoutes.listOfRemoved);
    app.put('/todos', isLoggedIn, allowCrossDomain, todosRoutes.put);
    app.post('/todos/:todoId', isLoggedIn, allowCrossDomain, todosRoutes.post);
    app["delete"]('/todos/:todoId', isLoggedIn, allowCrossDomain, todosRoutes["delete"]);
    app.get('/api/users/current', allowCrossDomain, require('./auth/get-user').get);
    app.get('/auth/vkontakte', passport.authenticate('vkontakte'));
    app.get('/auth/vkontakte/callback', passport.authenticate('vkontakte', {
      failureRedirect: '/'
    }), function(req, res) {
      return res.redirect('/');
    });
    return app.get('/logout', require('./auth/logout').get);
  };

}).call(this);

/*
//@ sourceMappingURL=index.map
*/
