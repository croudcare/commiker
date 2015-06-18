(function(commikerApp) {

  commikerApp.controller('StoriesNewController', [
    '$state',
    'StorySmooth',
    '$location',
    'MeLoginUsecase',
    StoriesNewController
  ]);

  /****************** PROTECTED ******************/

  function StoriesNewController($state, StorySmooth, $location, MeLoginUsecase) {
    var self = this;
  }

})(angular.module('commikerApp'));
