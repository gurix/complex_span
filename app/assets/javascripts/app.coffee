@cspan = angular.module('cspan',[
  'templates',
  'ngRoute',
  'controllers',
  'LocalStorageModule',
  'pascalprecht.translate',
  'ngCookies'
])

@cspan.config(['$translateProvider', ($translateProvider) ->
  $translateProvider.translations('en', @translations_en).translations('de', @translations_de).preferredLanguage('en')
  $translateProvider.useLocalStorage()
])

BigScreen.onexit = () ->
  location.href='#/session/fullscreendisabled'
  logger.push 'exitFullScreen'
