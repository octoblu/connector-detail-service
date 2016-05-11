_       = require 'lodash'
request = require 'request'
debug   = require('debug')('npm-registry-model:model')

class NPMRegistryModel
  constructor: ({ @npmUsername, @npmPassword })->
    @NPM_REGISTRY_API_URL = 'https://registry.npmjs.org'

  getDependenciesForPackage: (packageName, callback=->) =>
    getPackage packageName, (error, body) =>
      return callback error if error?
      latestVersion = body["dist-tags"]?.latest
      platformDependencies = body.versions[latestVersion].platformDependencies if latestVersion
      callback null, platformDependencies

  getPackage: (packageName, callback) =>
    request {
      method: 'GET'
      baseUrl: @NPM_REGISTRY_API_URL
      uri: "/#{packageName}"
      json: true
      auth:
        username: @npmUsername
        password: @npmPassword
    }, (error, response, body) =>
      return callback error if error?
      callback null, body

module.exports = NPMRegistryModel
