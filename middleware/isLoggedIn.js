// Generated by CoffeeScript 1.6.3
(function() {
  module.exports = function(req, res, next) {
    if (req.isAuthenticated()) {
      return next();
    }
    return res.redirect('/');
  };

}).call(this);

/*
//@ sourceMappingURL=isLoggedIn.map
*/
