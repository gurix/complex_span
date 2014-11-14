@cspan.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html",
        controller: 'SessionsController'
      )
      .when('/session/new',
        templateUrl: "session/new.html",
        controller: 'SessionsController'
      )
])
