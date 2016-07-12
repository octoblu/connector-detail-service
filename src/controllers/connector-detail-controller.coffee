class ConnectorDetailController
  constructor: ({ @npmDetailService, @githubDetailService }) ->

  getGithubDetails: (request, response) =>
    { owner, repo } = request.params
    @githubDetailService.getDetails { owner, repo }, (error, versions) =>
      return response.status(error.code).send({ error: error.message }) if error?
      response.status(200).send versions

  getNPMDetails: (request, response) =>
    { connectorName } = request.params
    @npmDetailService.getPackage connectorName, (error, registryResponse) =>
      return response.status(error.code).send({ error: error.message }) if error?
      response.status(200).send registryResponse

  getPlatformDependencies: (request, response) =>
    { connectorName } = request.params
    @npmDetailService.getDependenciesForPackage connectorName, (error, registryResponse) =>
      return response.status(error.code).send({ error: error.message }) if error?
      response.status(200).send registryResponse

module.exports = ConnectorDetailController
