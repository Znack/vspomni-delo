// Generated by CoffeeScript 1.6.3
(function() {
  module.exports = function(req, res, next) {
    if (req.user) {
      res.locals.user = req.user;
    } else {
      res.locals.user = null;
    }
    return next();
  };

}).call(this);

/*
//@ sourceMappingURL=passUserToLocals.map
*/
