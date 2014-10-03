detectExtension = (callback)->
  detectExtension = (extId, callback) ->
    $.ajax({
      dataType: "json",
      url: "chrome-extension://" + extId + "/manifest.json",
      success: ( result )->
        callback(null, {status: "success", extId: extId})
        return false
      error: ()->
        callback({status: "error", isChrome: true, message: "The extension wasn't detected", extId: extId})
        return false
    });

  isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
  extId = "djibejkjnciejcldejbajiihmickgloe"
  if isChrome is true
    detectExtension extId, callback
  else
    callback({status: "error", isChrome: false, message: "The browser should be a Chrome", extId: extId})

module.exports = {
  detectExtension: detectExtension
}