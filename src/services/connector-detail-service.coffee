_         = require 'lodash'
NPMClient = require 'npm-registry-client'
debug     = require('debug')('connector-detail-service:service')

class ConnectorDetailService
  constructor: ({ @npmUsername, @npmPassword, @npmEmail })->
    @NPM_REGISTRY_API_URL = 'https://registry.npmjs.org'
    @npmClient = new NPMClient {
      auth:
        username: @npmUsername
        password: @npmPassword
        email: @npmEmail
        alwaysAuth: true
    }

  getDependenciesForPackage: (packageName, callback=->) =>
    @getPackage packageName, (error, body) =>
      return callback error if error?
      latestVersion = body?["dist-tags"]?.latest
      platformDependencies = _.get(body, "versions['#{latestVersion}'].platformDependencies")
      callback null, platformDependencies

  getPackage: (packageName, callback) =>
    uri = "#{@NPM_REGISTRY_API_URL}/#{packageName}"
    @npmClient.get uri, {}, (error, response) =>
      return callback @_createError error.code, error.message if error?
      callback null, response

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = ConnectorDetailService
