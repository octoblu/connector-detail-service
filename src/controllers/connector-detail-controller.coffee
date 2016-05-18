class ConnectorDetailController
  constructor: ({ @connectorDetailService }) ->

  getPackage: (request, response) =>
    { connectorName } = request.params
    @connectorDetailService.getPackage connectorName, (error, registryResponse) =>
      return response.status(error.code).send({ error: error.message }) if error?
      response.status(200).send registryResponse

  getPlatformDependencies: (request, response) =>
    { connectorName } = request.params
    @connectorDetailService.getDependenciesForPackage connectorName, (error, registryResponse) =>
      return response.status(error.code).send({ error: error.message }) if error?
      response.status(200).send registryResponse

module.exports = ConnectorDetailController
