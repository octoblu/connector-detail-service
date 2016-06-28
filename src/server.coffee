cors                = require 'cors'
morgan              = require 'morgan'
express             = require 'express'
bodyParser          = require 'body-parser'
errorHandler        = require 'errorhandler'
meshbluHealthcheck  = require 'express-meshblu-healthcheck'
NPMDetailService    = require './services/npm-detail-service'
GithubDetailService = require './services/github-detail-service'
Router              = require './router'
debug               = require('debug')('connector-detail-service:server')

class Server
  constructor: (options)->
    {@disableLogging, @port} = options
    {@npmUsername, @npmPassword, @npmEmail} = options
    {@githubToken} = options

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use cors()
    app.use errorHandler()
    app.use meshbluHealthcheck()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    app.options '*', cors()

    npmDetailService = new NPMDetailService {@npmUsername, @npmPassword, @npmEmail}
    githubDetailService = new GithubDetailService {@githubToken}
    router = new Router { npmDetailService, githubDetailService }

    router.route app

    @server = app.listen @port, callback

  stop: (callback) =>
    @server.close callback

module.exports = Server
