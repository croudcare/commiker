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
    self.page = 1;
    self.perPage = 5;

    self.latestSprint = null;
    self.previousSprints = [];
    self.moreToLoad = true;

    self.loadMoreSprints = loadMoreSprints;

    loadMoreSprints();

    function loadMoreSprints() {
      if(self.moreToLoad) {
        SprintSmooth.find('', { page: self.page, per_page: self.perPage })
          .success(onSuccess);
      }

      function onSuccess(sprints, code) {
        var sprintsCount = sprints.length;

        if(self.page == 1 && sprints[0].active)
          self.latestSprint = sprints.shift();

        self.previousSprints = self.previousSprints.concat(sprints);

        // hide load more button if no more
        if(sprintsCount < self.perPage)
          self.moreToLoad = false;

        self.page++;
      }
    }
  }

})(angular.module('commikerApp'));
