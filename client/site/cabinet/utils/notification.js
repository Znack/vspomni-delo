// Generated by CoffeeScript 1.6.3
(function() {
  var ALLOWED_TYPES, Notification,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  ALLOWED_TYPES = ["standart", "warning", "loading"];

  Notification = (function() {
    function Notification() {
      this.createNotificationObject = __bind(this.createNotificationObject, this);
      this._notifications = [];
    }

    Notification.prototype.findSimilar = function(type) {
      var notification, _i, _len, _ref;
      _ref = this._notifications;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        notification = _ref[_i];
        if (notification.type === type) {
          return notification;
        }
      }
      return false;
    };

    Notification.prototype.createNotificationObject = function(text, type) {
      var notificationObject,
        _this = this;
      notificationObject = {
        text: text
      };
      if (__indexOf.call(ALLOWED_TYPES, type) >= 0) {
        notificationObject.type = type;
      } else {
        notificationObject.type = void 0;
      }
      notificationObject.remove = function() {
        return _this._notifications.splice(_this._notifications.indexOf(notificationObject), 1);
      };
      return notificationObject;
    };

    Notification.prototype.add = function(text, type, timeout, scope) {
      var notificationObject, similar;
      if (type == null) {
        type = 'standart';
      }
      if (timeout == null) {
        timeout = null;
      }
      if (scope == null) {
        scope = {};
      }
      similar = this.findSimilar(type);
      if (similar) {
        return similar;
      }
      notificationObject = this.createNotificationObject(text, type);
      this._notifications.push(notificationObject);
      if (timeout) {
        setTimeout(function() {
          notificationObject.remove();
          return scope.$apply();
        }, timeout);
      }
      return notificationObject;
    };

    Notification.prototype.all = function() {
      return this._notifications;
    };

    return Notification;

  })();

  module.exports = Notification;

}).call(this);

/*
//@ sourceMappingURL=notification.map
*/
