(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$state',
    '$rootScope',
    'SprintSmooth',
    'UsersShowUseCase',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($rootScope, $state, SprintSmooth, UsersShowUseCase) {
    var self = this;

    self.currentSprint = null;
    self.listView = false;

    self.showUser = showUser;
    self.setListView = setListView;
    self.setDefaultView = setDefaultView;

    findCurrentSprint();

    function findCurrentSprint() {
      SprintSmooth.find('active')
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprint) {
        self.currentSprint = sprint;
      }

      function onError(response) {
        // debugger
      }
    }

    function setListView() {
      self.listView = true;
    }

    function setDefaultView() {
      self.listView = false;
    }

    function showUser(user) {
      UsersShowUseCase.perform({ user: user });
    }
  }

})(angular.module('commikerApp'));
