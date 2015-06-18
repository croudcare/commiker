(function(commikerApp) {

  commikerApp.controller('SprintsShowController', [
    '$state',
    'SprintSmooth',
    SprintsShowController
  ]);

  /****************** PROTECTED ******************/

  function SprintsShowController($state, SprintSmooth) {
    var self = this;

    self.sprint = null;

    if($state.params.id.length == 0)
      $state.go('home');

    findSprint($state.params.id);

    /****************** PRIVATE ******************/

   function findSprint(id) {
      SprintSmooth.find(id)
        .success(onSuccess)
        .error(onError)

      function onSuccess(sprint) {
        debugger
        self.sprint = sprint;
      }

      function onError(response) {
        debugger
      }
    }

  }

})(angular.module('commikerApp'));
