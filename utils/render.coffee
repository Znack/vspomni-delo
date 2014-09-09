module.exports = (request, response, templateName, context={}) ->
  full_context = {}
#  for own prop of response.locals
#    full_context[prop] = response.locals[prop]
  for own prop of context
    full_context[prop] = context[prop]
  return response.render(templateName, full_context)