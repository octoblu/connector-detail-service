cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
debug              = require('debug')('connector-detail-service:server')
Router             = require './router'
ConnectorDetailService = require './services/connector-detail-service'

class Server
  constructor: ({@disableLogging, @port, @npmUsername, @npmPassword, @npmEmail })->

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use meshbluHealthcheck()
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    app.options '*', cors()

    connectorDetailService = new ConnectorDetailService {@npmUsername, @npmPassword, @npmEmail}
    router = new Router {connectorDetailService}

    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
