module.exports = (req, res, next)->
  if req.user
    res.locals.user = req.user
  else
    res.locals.user = null
  return next()