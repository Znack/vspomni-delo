// Generated by CoffeeScript 1.6.3
(function() {
  var detectExt, launchDetecting, onerror, onsuccess;

  onerror = function(extName, extID) {
    return console.log(extName + ' Not Installed');
  };

  onsuccess = function(extName, extID) {
    return console.log(extName + ' installed');
  };

  detectExt = function(extName, extID) {
    var s;
    s = document.createElement('script');
    s.onload = function() {
      return onsuccess(extName, extID);
    };
    s.onerror = function() {
      return onerror(extName, extID);
    };
    s.src = "chrome-extension://" + extID + "/manifest.json";
    return document.body.appendChild(s);
  };

  launchDetecting = function() {
    var isChrome;
    isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
    if (isChrome === true) {
      return window.onload = function() {
        return detectExt('Вспомни Дело', 'djibejkjnciejcldejbajiihmickgloe');
      };
    }
  };

  module.exports = launchDetecting;

}).call(this);