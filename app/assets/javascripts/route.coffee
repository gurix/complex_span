@cspan.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html",
        controller: 'SessionsController'
      )
      .when('/session/instruction_1',
        templateUrl: "session/instruction_1.html",
        controller: 'SessionsController'
      )
      .when('/session/instruction_1_1',
        templateUrl: "session/instruction_1_1.html",
        controller: 'SessionsController'
      )
      .when('/session/fullscreendisabled',
        templateUrl: "session/fullscreendisabled.html",
        controller: 'SessionsController'
      )
])
