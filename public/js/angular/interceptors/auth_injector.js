(function(commikerApp) {

  commikerApp.factory('AuthInjector', ['$q', '$location', '$window', AuthInjector]);

  /****************** PROTECTED ******************/

  function AuthInjector($q, $location, $window) {

    return {
      request: function (config) {
        config.headers = config.headers || {};

        if ($.api_client.authToken) {
          config.headers.AUTHORIZATION = $.api_client.authToken;
        }

        return config;
      }
    };

  }

})(angular.module('commikerApp'));
