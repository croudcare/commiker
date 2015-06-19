(function(commikerApp) {

  commikerApp.factory('SprintSmooth', [
    'SmoothOperator',
    'SprintModel',
    SprintSmooth
  ]);

  /****************** PROTECTED ******************/

  function SprintSmooth(SmoothOperator, SprintModel) {
    var sprint = SmoothOperator.new({
      url: $.api_client.endpoint,
      modelFactory: SprintModel,
      resourceName: 'sprint',
      resourcesName: 'sprints',
    });

    return sprint;
  }

})(angular.module('commikerApp'));
