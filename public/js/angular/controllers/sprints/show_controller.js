(function(commikerApp) {

  commikerApp.controller('SprintsShowController', [
    '$scope',
    '$state',
    'SprintSmooth',
    'UsersShowUseCase',
    SprintsShowController
  ]);

  /****************** PROTECTED ******************/

  function SprintsShowController($scope, $state, SprintSmooth, UsersShowUseCase) {
    var self = this;

    var id = $state.params.id;

    self.listView = false;
    self.showUser = showUser;
    self.setListView = setListView;
    self.setDefaultView = setDefaultView;

    self.sprint = null;

    findCurrentSprint($state.params.id);

    function findCurrentSprint(id) {
      SprintSmooth.find(id)
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprint, code) {
        // no active sprint
        if(code == 204)
          $state.go('sprints')
        else
          self.sprint = sprint;
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
      UsersShowUseCase.perform({ user: user, sprint: self.sprint })
    }
  }

})(angular.module('commikerApp'));
