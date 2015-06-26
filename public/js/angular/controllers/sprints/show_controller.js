(function(commikerApp) {

  commikerApp.controller('SprintsShowController', [
    '$scope',
    '$state',
    '$pusher',
    'SprintSmooth',
    'SprintModel',
    'UsersShowUseCase',
    SprintsShowController
  ]);

  /****************** PROTECTED ******************/

  function SprintsShowController($scope, $state, $pusher, SprintSmooth, SprintModel, UsersShowUseCase) {
    var self = this;

    var id = $state.params.id;

    self.listView = false;
    self.showUser = showUser;
    self.setListView = setListView;
    self.setDefaultView = setDefaultView;
    self.editableSprint = (id == 'active');
    self.deleteStory = deleteStory;

    self.sprint = null;

    findCurrentSprint($state.params.id);

    $pusher(window.pusherClient)
      .subscribe('commiker_' + $.api_client.env, { encrypted: false })
      .bind('sprints.show', function(data) {
        self.sprint = SprintModel.new(data);
      });

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

    function deleteStory(storyId) {
      var that = self;

      StorySmooth.destroy(storyId)
        .success(onSuccess)
        .error(onError)

      function onSuccess() {
        _.remove(self.user.stories, function(story){
          return (story.id == storyId);
        });
      }

      function onError() {
        debugger
      }
    }

  }

})(angular.module('commikerApp'));
