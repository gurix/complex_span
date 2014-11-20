@cspan = angular.module('cspan',[
  'templates',
  'ngRoute',
  'controllers',
  'LocalStorageModule'
])

BigScreen.onexit = () ->
  location.href='#/session/fullscreendisabled'
  logger.push 'exitFullScreen'
