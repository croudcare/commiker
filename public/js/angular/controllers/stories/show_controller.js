(function(commikerApp) {

  commikerApp.controller('StoriesShowController', [
    '$state',
    'StorySmooth',
    StoriesShowController
  ]);

  /****************** PROTECTED ******************/

  function StoriesShowController($state, StorySmooth) {
    var self = this;

    if($state.params.name.length == 0)
      $state.go('home');

  }

})(angular.module('commikerApp'));
