class BaseBackend
  constructor: ()->

  handle: (request, sendResponse)->
    if request.method of @
      if typeof @[request.method] == "function"
        return @[request.method](request, sendResponse)
      else
        return sendResponse(@[request.method])
    @app.tracker.sendEvent(
      'Error in extension',
      'Background doesn\'t recognize backend\'s method',
      "backendName: #{request.backendName}, backendMethod: #{request.method}"
    )
    return sendResponse(undefined)

  connect: (params)->
    url = params.url
    callback = params.callback || ()->
    method = params.method || "GET"
    requestParams = params.data || ""
    doCallOtherDomain = ()->
      XHR = window.XDomainRequest || window.XMLHttpRequest
      xhr = new XHR();
      xhr.open(method, url, true)
      xhr.setRequestHeader("Content-type", "application/json");
      # замена onreadystatechange
      xhr.onload = ()->
        response = JSON.parse(@responseText)
        if response.status and response.status == 'error'
          callback(new Error("Вы не авторизованы"), null)
        callback(null, response)
      xhr.onerror = ()->
        callback(new Error("Ошибка соединения"), null)
      xhr.withCredentials = true;
      if requestParams
        xhr.send(JSON.stringify(requestParams))
      else
        xhr.send()

    try
      doCallOtherDomain()
    catch e
      callback(new Error("В этом браузере вы не можете загрузить окно"), null)

module.exports = BaseBackend