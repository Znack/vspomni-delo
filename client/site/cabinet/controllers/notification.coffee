detectExtension = require('../../common.js').detectExtension

notificationControllers = angular.module('notificationControllers', []);

notificationControllers.controller('NotificationCtrl', ['$scope', ($scope)->
  detectExtension((err, success)->
    if err? and err.isChrome
      $scope.notificationExtensionNotInstalled = true
  )
])