'use strict';

// Declare app level module which depends on filters, and services
angular.module('blog', ['myApp.filters', 'myApp.services', 'myApp.directives']).
  config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/', {templateUrl: 'partials/top.html', controller: TopCtrl});
    $routeProvider.when('/view1', {templateUrl: 'partials/partial2.html', controller: MyCtrl2});
    $routeProvider.when('/view2', {templateUrl: 'partials/partial2.html', controller: MyCtrl2});
    $routeProvider.otherwise({redirectTo: '/'});
  }]);
