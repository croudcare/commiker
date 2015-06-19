(function(commikerApp) {

  commikerApp.factory('StorySmooth', [
    'SmoothOperator',
    'StoryModel',
    StorySmooth
  ]);

  /****************** PROTECTED ******************/

  function StorySmooth(SmoothOperator, StoryModel) {
    var story = SmoothOperator.new({
      url: $.api_client.endpoint,
      modelFactory: StoryModel,
      resourceName: 'story',
      resourcesName: 'stories',
    });

    return story;
  }

})(angular.module('commikerApp'));
