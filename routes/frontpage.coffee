url = require('url')

exports.get = (req, res, next)->
  query = url.parse(req.url, true).query
  if req.user and not ("no_redirect" of query)
    return res.redirect('/cabinet')
  else
    return res.render('frontpage')