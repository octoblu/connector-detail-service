_             = require 'lodash'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions =
      port:           process.env.PORT || 80
      disableLogging: process.env.DISABLE_LOGGING == "true"
      npmUsername:    process.env.NPM_USERNAME
      npmPassword:    process.env.NPM_PASSWORD
      npmEmail:       process.env.NPM_EMAIL

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing required environment variable: NPM_USERNAME') if _.isEmpty @serverOptions.npmUsername
    @panic new Error('Missing required environment variable: NPM_PASSWORD') if _.isEmpty @serverOptions.npmPassword
    @panic new Error('Missing required environment variable: NPM_EMAIL') if _.isEmpty @serverOptions.npmEmail

    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "Server listening on #{address}:#{port}"

command = new Command()
command.run()
