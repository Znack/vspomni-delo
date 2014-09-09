// Generated by CoffeeScript 1.6.3
(function() {
  var frameControllers, _removeItem;

  frameControllers = angular.module('frameControllers', []);

  _removeItem = function(arr, item) {
    var index;
    index = arr.indexOf(item);
    if (index > -1) {
      return arr.splice(index, 1);
    }
  };

  frameControllers.controller('FrameListCtrl', [
    '$scope', 'Frame', function($scope, Frame) {
      $scope.isAuthorized = true;
      $scope.frames = Frame.query(function(frames, getResponseHeaders) {
        if (frames.length === 0) {
          return Frame.create({}, function(frame) {
            return $scope.frames.push(frame);
          });
        }
      });
      $scope.createFrame = function() {
        return Frame.create({}, function(frame) {
          return $scope.todos.push(frame);
        });
      };
      $scope.updateFrame = function(frame) {
        return frame.$update();
      };
      return $scope.removeFrame = function(frame) {
        frame.$remove();
        return _removeItem($scope.frames, frame);
      };
    }
  ]);

  module.exports = frameControllers;

}).call(this);