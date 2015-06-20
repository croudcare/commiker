(function(commikerApp) {

  commikerApp.factory('SprintModel', ['UserModel', SprintModel]);

  function SprintModel(UserModel) {

    return {
      new: function(object) {
        object.users = _.map(object.users, function(user) {
          user.completedStories = completedStories;
          user.totalStories = totalStories;
          user.completionPerc = completionPerc;

          return user;
        });

        return object;
      }
    }
  }

  /****************** PROTECTED ******************/

  function completedStories() {
    var stories = this.stories.filter(function(story) {
      if(story.completion_percentage == 100)
        return story;
    });

    return stories.length;
  }

  function totalStories() {
    return this.stories.length;
  }

  function completionPerc() {
    var total = this.totalStories() * 100;

    if(total == 0)
      return 0;

    var completionSumAry = _.map(this.stories, function(story){
      return story.completion_percentage;
    });

    completionSum = _.sum(completionSumAry);

    return Math.round(completionSum * 100 / total)
  }

})(angular.module('commikerApp'));
