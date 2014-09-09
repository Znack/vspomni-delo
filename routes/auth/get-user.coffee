exports.get = (req, res, next)->
  if req.user
    return res.json(req.user)
  else
    return res.json(403, {status: "error", err: "User is anonymous"})