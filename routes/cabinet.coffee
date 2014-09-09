exports.get = (req, res, next)->
  if not req.user
    return res.redirect('/')
  return res.render('cabinet')