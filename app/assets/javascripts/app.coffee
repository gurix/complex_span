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

@SessionData= () ->
  JSON.parse(localStorage['ls.session'])

@controllers = angular.module('controllers',[])

BigScreen.onexit = () ->
  location.href='#/session/fullscreendisabled'
  logger.push 'exitFullScreen'

do -> Array::shuffle ?= ->
  for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  @
