app = angular.module('app',['ngResource'])

app.controller('WelcomeController',['$scope',($scope) ->
  $scope.firstname = "Michael"
  $scope.lastname = "Ntow"
])