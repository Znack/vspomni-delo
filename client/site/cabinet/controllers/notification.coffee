detectExtension = require('../../common.js').detectExtension

notificationControllers = angular.module('notificationControllers', []);

notificationControllers.controller('NotificationCtrl', ['$scope', ($scope)->
  try
    $scope.notificationExtensionNotInstalledClosed = localStorage.getItem("notificationExtensionNotInstalledClosed") or false
    isLocalStorageAvailable = true
  catch
    $scope.notificationExtensionNotInstalledClosed = false

  $scope.closeNotificationExtensionNotInstalled = ()->
    $scope.notificationExtensionNotInstalledClosed = !$scope.notificationExtensionNotInstalledClosed
    if isLocalStorageAvailable
      localStorage.setItem("notificationExtensionNotInstalledClosed", $scope.notificationExtensionNotInstalledClosed)

  detectExtension((err, success)->
    if err? and err.isChrome
      $scope.notificationExtensionNotInstalled = true
  )
])