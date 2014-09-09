exports.get = (req, res, next)->
  req.logout();
  res.redirect('/')
