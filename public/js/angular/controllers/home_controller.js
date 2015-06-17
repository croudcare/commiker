(function(commikerApp) {

  commikerApp.controller('HomeController', [
    '$state',
    'StorySmooth',
    'MeLoginUsecase',
    HomeController
  ]);

  /****************** PROTECTED ******************/

  function HomeController($state, StorySmooth, MeLoginUsecase) {
    var self = this;

    // self.today = moment();
    // self.todayStr = todayStr;

    // self.currentDay = self.today;
    // self.nextStr = nextStr;

    // self.gems = {};
    // self.bumpGem = bumpGem;
    // self.sortedKeys = sortedKeys;

    // getGemsByDay(self.todayStr());
    // getGemsByDay(nextStr());

    // function sortedKeys() {
    //   return _.keys(self.gems)
    //     .sort(function(a, b){ return parseInt(b)-parseInt(a) });
    // }

    // function getGemsByDay(date) {
    //   StorySmooth.find('by_day', { date: date })
    //     .success(onSuccess);

    //   function onSuccess(response) {
    //     self.gems[+moment(date).toDate()] = response.gem_posts;
    //   }
    // }

    // function bumpGem(gemId) {
    //   StorySmooth.patch('bump', { id: gemId })
    //     .success(onSuccess)
    //     .error(onError);

    //   function onSuccess(response) {
    //     _.forEach(self.gems, function(gems, day){
    //       _.each(gems, function(gem){
    //         if(gem.id == response.gem_post.id) {
    //           gem.bumped = true;
    //           gem.up_count += 1;
    //         }
    //       });
    //     });
    //   }

    //   function onError(response, status) {
    //     if(status == 401) {
    //       MeLoginUsecase.perform({ gemId: gemId, from: '/' });
    //     }
    //   }
    // }

    // function todayStr() {
    //   return self.today.format('YYYY-MM-DD');
    // }

    // function currentDayStr() {
    //   return self.currentDay.format('YYYY-MM-DD');
    // }

    // function nextStr() {
    //   return self.currentDay.subtract(1, 'day').format('YYYY-MM-DD');
    // }

  }

})(angular.module('commikerApp'));
