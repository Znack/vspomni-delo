require('./services/todo.js')
require('./controllers/todo.js')
require('./directives/contenteditable.js')
require('./checkExtension.js')

angular.module('todo', [
  'ngResource',
  'ngCookies',
  'ui.bootstrap.datetimepicker',
  'contenteditableDirective',
  'todoServices',
  'todoControllers',
])