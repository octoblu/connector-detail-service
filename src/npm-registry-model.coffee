_       = require 'lodash'
request = require 'request'
debug   = require('debug')('npm-registry-model:model')

class NPMRegistryModel
  constructor: ->
    @NPM_REGISTRY_API_URL = 'https://registry.npmjs.org'

  get: (packageName, callback=->) =>
    request.get "#{@NPM_REGISTRY_API_URL}/#{packageName}", json: true, (error, response, body) =>
      return callback error if error?
      callback null, body

  getDependenciesForPackage: (packageName, callback=->) =>
    request.get "#{@NPM_REGISTRY_API_URL}/#{packageName}", json: true, (error, response, body) =>
      return callback error if error?

      latestVersion = body["dist-tags"]?.latest
      platformDependencies = body.versions[latestVersion].platformDependencies if latestVersion
      callback null, platformDependencies

module.exports = NPMRegistryModel
