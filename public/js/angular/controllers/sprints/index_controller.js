(function(commikerApp) {

  commikerApp.controller('SprintsIndexController', [
    '$state',
    '$location',
    'SprintSmooth',
    SprintsIndexController
  ]);

  /****************** PROTECTED ******************/

  function SprintsIndexController($state, $location, SprintSmooth) {
    var self = this;

    self.sprints = [];

    findSprint('active');

    function findSprint(id, cbSuccess) {
      if(cbSuccess == undefined)
        cbSuccess = onSuccess;

      SprintSmooth.find('active')
        .success(cbSuccess)
        .error(onError)

      function onSuccess(sprint, code) {
        // no active sprint
        if(code != 204)
          $state.go('sprints-show', { id: 'active' });
        else
          listSprints();
      }

      function onError(response) {
        // debugger
      }
    }

    function listSprints() {

      SprintSmooth.find('')
        .success(onSuccess);

      function onSuccess(sprints, code) {
        self.latestSprint = sprints.shift();
        self.previousSprints = sprints;
      }

    }
  }

})(angular.module('commikerApp'));
