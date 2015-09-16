_       = require 'lodash'
debug   = require('debug')('connector-detail-service:controller')
request = require 'request'
NPMRegistryModel = require './npm-registry-model'

class ConnectorController
  constructor: ->
    debug "Constructor"

  getPackage: (request, response) =>
    connectorName = request.params.connectorName
    npmRegistryModel = new NPMRegistryModel

    npmRegistryModel.get connectorName, (error, registryResponse) =>
      return response.status(500).end() if error?
      response.status(200).send registryResponse

  getPlatformDependencies: (request, response) =>
    connectorName = request.params.connectorName
    npmRegistryModel = new NPMRegistryModel

    npmRegistryModel.getDependenciesForPackage connectorName, (error, registryResponse) =>
      return response.status(500).end() if error?
      response.status(200).send registryResponse

module.exports = ConnectorController
