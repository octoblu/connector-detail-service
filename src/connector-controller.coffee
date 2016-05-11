_                = require 'lodash'
request          = require 'request'
NPMRegistryModel = require './npm-registry-model'
debug            = require('debug')('connector-detail-service:controller')

class ConnectorController
  constructor: ({ npmUsername, npmPassword }) ->
    @npmRegistryModel = new NPMRegistryModel { npmUsername, npmPassword }

  getPackage: (request, response) =>
    connectorName = request.params.connectorName
    @npmRegistryModel.get connectorName, (error, registryResponse) =>
      return response.status(500).end() if error?
      response.status(200).send registryResponse

  getPlatformDependencies: (request, response) =>
    connectorName = request.params.connectorName
    @npmRegistryModel.getDependenciesForPackage connectorName, (error, registryResponse) =>
      return response.status(500).end() if error?
      response.status(200).send registryResponse

module.exports = ConnectorController
