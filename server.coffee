express             = require 'express'
bodyParser          = require 'body-parser'
cors                = require 'cors'
morgan              = require 'morgan'
errorhandler        = require 'errorhandler'
healthcheck         = require 'express-meshblu-healthcheck'
ConnectorController = require './src/connector-controller'

app = express()
app.use bodyParser.json()
app.use cors()
app.use errorhandler()
app.use healthcheck()
app.use morgan 'dev'

connectorController = new ConnectorController

app.get '/:connectorName', connectorController.getPackage
app.get '/:connectorName/dependencies', connectorController.getPlatformDependencies

server = app.listen (process.env.PORT || 80), ->
  host = server.address().address
  port = server.address().port

  console.log "Connector Detail Service started http://#{host}:#{port}"
