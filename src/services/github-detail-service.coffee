_       = require 'lodash'
request = require 'request'
debug   = require('debug')('connector-detail-service:github-detail-service')

class GithubDetailService
  constructor: ()->

  getDetails: ({ owner, repo }, callback) =>
    options =
      baseUrl: 'https://api.github.com/'
      uri: "/repos/#{owner}/#{repo}/releases"
      headers:
        'User-Agent': 'Octoblu Connector Detail Service'
      json: true

    request.get options, (error, response, bodyResponse={}) =>
      return callback @_createError 500, error.message if error?
      return callback @_createError response.statusCode, bodyResponse.message if response.statusCode > 299
      details = {
        owner,
        repo,
        tags: {}
      }
      _.each bodyResponse, ({ tag_name, created_at, published_at, assets, prerelease, draft }) =>
        details.tags[tag_name] ?= {
          tag: tag_name,
          created_at,
          published_at,
          prerelease,
          draft,
          assets: []
        }
        _.each assets, ({ name }) =>
          details.tags[tag_name].assets.push {
            name,
          }

      details.latest = _.first _.values details.tags
      callback null, details

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = GithubDetailService
