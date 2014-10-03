require('./services/todo.js')
require('./controllers/todo.js')
require('./controllers/notification.js')
require('./directives/contenteditable.js')

angular.module('todo', [
  'ngResource',
  'ngCookies',
  'ui.bootstrap.datetimepicker',
  'contenteditableDirective',
  'todoServices',
  'todoControllers',
  'notificationControllers',
])