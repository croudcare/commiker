(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$state',
    'SprintSmooth',
    'SprintFactory',
    'UsersShowUseCase',
    'MeLoginUsecase',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($state, SprintSmooth, SprintFactory, UsersShowUseCase, MeLoginUsecase) {
    var self = this;

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
        SprintFactory.current = sprint;
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
      UsersShowUseCase.perform({ user: user })
    }
  }

})(angular.module('commikerApp'));
