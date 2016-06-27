ConnectorDetailController = require './controllers/connector-detail-controller'

class Router
  constructor: ({ @npmDetailService, @githubDetailService }) ->
  route: (app) =>
    connectorDetailController = new ConnectorDetailController { @npmDetailService, @githubDetailService }

    app.get '/github/:owner/:repo', connectorDetailController.getGithubDetails
    app.get '/:connectorName', connectorDetailController.getNPMDetails
    app.get '/:connectorName/dependencies', connectorDetailController.getPlatformDependencies

module.exports = Router
