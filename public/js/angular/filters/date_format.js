(function(commikerApp) {

  commikerApp.filter('dateformat', function() {

    return function (input, format) {
      if (!input) { return input; }

      format = format || 'first';

      return moment(input).format(format);
    };

  });

})(angular.module('commikerApp'));
