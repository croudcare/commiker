(function(commikerApp) {

  commikerApp.factory('StorySmooth', [
    'SmoothOperator',
    'StoryModel',
    StorySmooth
  ]);

  /****************** PROTECTED ******************/

  function StorySmooth(SmoothOperator, StoryModel) {
    var story = SmoothOperator.new({
      url: 'http://localhost:5000/api/v0/',
      modelFactory: StoryModel,
      resourceName: 'story',
      resourcesName: 'stories',
    });

    return story;
  }

})(angular.module('commikerApp'));
