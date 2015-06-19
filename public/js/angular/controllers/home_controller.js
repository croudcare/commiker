(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$state',
    'SprintSmooth',
    'UsersShowUseCase',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($state, SprintSmooth, UsersShowUseCase) {
    var self = this;

    self.currentSprint = null;
    self.listView = false;

    self.showUser = showUser;
    self.setListView = setListView;
    self.setDefaultView = setDefaultView;

    findCurrentSprint();

    function findCurrentSprint() {
      SprintSmooth.find('', { page: 1, per_page: 1 })
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprints) {
        self.currentSprint = sprints[0];
      }

      function onError(response) {
        debugger
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
