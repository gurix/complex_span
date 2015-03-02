@cspan.config([ '$routeProvider','$locationProvider',
  ($routeProvider, $locationProvider)->
    $routeProvider
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
      ).when('/test',
        templateUrl: "test/index.html",
        controller: 'TrialsController'
      ).when('/finishing',
        templateUrl: "finishing/index.html",
        controller: 'FinishingController'
      ).when('/:language?',
        templateUrl: "index.html",
        controller: 'SessionsController'
      )
])
