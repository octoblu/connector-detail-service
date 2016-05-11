ConnectorDetailController = require './controllers/connector-detail-controller'

class Router
  constructor: ({@connectorDetailService}) ->
  route: (app) =>
    connectorDetailController = new ConnectorDetailController {@connectorDetailService}

    app.get '/:connectorName', connectorDetailController.getPackage
    app.get '/:connectorName/dependencies', connectorDetailController.getPlatformDependencies

module.exports = Router
