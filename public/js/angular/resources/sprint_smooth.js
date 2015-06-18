(function(commikerApp) {

  commikerApp.factory('SprintSmooth', [
    'SmoothOperator',
    'SprintModel',
    SprintSmooth
  ]);

  /****************** PROTECTED ******************/

  function SprintSmooth(SmoothOperator, SprintModel) {
    var sprint = SmoothOperator.new({
      url: 'http://localhost:5000/api/v0/',
      modelFactory: SprintModel,
      resourceName: 'sprint',
      resourcesName: 'sprints',
    });

    return sprint;
  }

})(angular.module('commikerApp'));
