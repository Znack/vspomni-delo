onerror = (extName, extID)->
  console.log(extName + ' Not Installed');

onsuccess = (extName, extID)->
  console.log(extName + ' installed');

detectExt = (extName,extID)->
  s = document.createElement('script')
  s.onload = ()->
    onsuccess(extName,extID)
  s.onerror = ()->
    onerror(extName,extID)
  s.src = "chrome-extension://#{extID }/manifest.json";
  document.body.appendChild(s)

launchDetecting = ()->
  isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;

  if (isChrome==true)
    window.onload = () ->
      detectExt('Вспомни Дело','djibejkjnciejcldejbajiihmickgloe')

module.exports = launchDetecting