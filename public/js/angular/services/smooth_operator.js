(function(commikerApp, _) {

  commikerApp.factory('SmoothOperator', [
    '$http',
    function($http) {
      return {
        new: function(config) {
          return new SmoothOperator($http, config);
        }
      };
    }
  ]);

  /****************** PROTECTED ******************/

  function SmoothOperator($http, config) {
    var self                = this,
        instancesProvider   = new SmoothInstanceProvider($http, config, makeTheCall, transformRESTResponse);

    self.find               = find;
    self.create             = create;
    self.patch              = patch;
    self.newInstance        = instancesProvider.new;
    self.url                = config.url;

    /****************** PROTECTED ******************/

    function find(relativePath, params, options) {
      var defaulOptions = {
        httpVerb: 'GET',
        transformResponse: transformRESTResponse
      }

      return makeTheCall(relativePath, params, null, _.merge({}, defaulOptions, options));
    }

    function create(relativePath, body, options) {
      var defaulOptions = {
        httpVerb: 'POST',
        transformResponse: transformRESTResponse
      }

      return makeTheCall(relativePath, null, body, _.merge({}, defaulOptions, options));
    }

    function patch(relativePath, body, options) {
      var defaulOptions = {
        httpVerb: 'PATCH',
        transformResponse: transformRESTResponse
      }

      relativePath = body.id + '/' + relativePath;

      return makeTheCall(relativePath, null, body, _.merge({}, defaulOptions, options));
    }

    /****************** PRIVATE ******************/

    function makeTheCall(relativePath, params, body, _options) {
      var defaulOptions = { url: config.url, resourceName: config.resourceName, resourcesName: config.resourcesName },
          options       = _.merge({}, defaulOptions, _options),
          url           = options.url + (options.resourcesName || ''),
          data          = {};

      // backslash sanitize
      url = (url[-1] !== '/') ? (url + '/' + relativePath) : (url + relativePath);

      // url params encoding
      if (!_.isEmpty(params)) { url += '?' + jQuery.param(params) }

      // rest body
      if (options.resourceName && body && body[options.resourceName] === undefined) {
        data[options.resourceName] = body;
      } else {
        data = body;
      }

      return $http({
        url:                url,
        data:               data,
        method:             options.httpVerb,
        transformResponse:  options.transformResponse
      });
    }

    function transformRESTResponse(stringData, header) {
      var resource  = angular.fromJson(stringData),
          resources = resource[config.resourcesName];

      if (_.isArray(resources)) {
        _.forEach(resource, function(value, key) {
          if (key === config.resourcesName) {
            transformArray(resources);
          } else {
            resources[key] = value;
          }
        });

        resource = resources;
      } else if (_.isArray(resource)) {
        transformArray(resource);
      } else if (_.isObject(resource)) {
        self.newInstance(resource);
      }

      return resource;
    }

    function transformArray(array) {
      return _.forEach(array, function(object) { self.newInstance(object); });
    }
  }

  function SmoothInstanceProvider($http, config, makeTheCall, transformRESTResponse) {
    return {
      new: function(object) {
        object.save = save;

        if (config.modelFactory) { config.modelFactory.new(object); }

        return object;
      }
    };

    /****************** PROTECTED ******************/

    function save(relativePath, _body, _options) {
      var body          = {},
          defaulOptions = {
            httpVerb:          (this[config.primaryKey || 'id']) ? 'PUT' : 'POST',
            resourceName:      config.resourceName,
            transformResponse: transformRESTResponse
          },
          options       = Utils.merge({}, defaulOptions, _options);

      if (Utils.isPresent(options.resourceName)) {
        body[options.resourceName] = _body;
      } else {
        body = _body;
      }

      return makeTheCall(relativePath, null, body, options);
    }
  }

})(angular.module('commikerApp'), window._);
