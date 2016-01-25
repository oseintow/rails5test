app = angular.module('app',['ngResource'])
.controller 'WelcomeController',['$scope',($scope) =>
  $scope.firstname = "Michael"
  $scope.lastname  = "Ntow"
]