(function(commikerApp) {

  commikerApp.controller('UsersShowModalController', [
    '$modalInstance',
    'user',
    'editableSprint',
    '$rootScope',
    'StorySmooth',
    UsersShowModalController
  ]);

  /****************** PROTECTED ******************/

  function UsersShowModalController($modalInstance, user, editableSprint, $rootScope, StorySmooth) {
    var self = this;

    self.user = user;
    self.cancel = cancel;
    self.deleteStory = deleteStory;
    self.editableSprint = editableSprint;

    /****************** PRIVATE  ******************/

    function cancel() {
      $modalInstance.dismiss('cancel');
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
