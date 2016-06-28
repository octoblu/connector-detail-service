_       = require 'lodash'
request = require 'request'
moment  = require 'moment'
debug   = require('debug')('connector-detail-service:github-detail-service')

class GithubDetailService
  constructor: ({ @githubToken }) ->
    @cache = {}

  getDetails: ({ owner, repo }, callback) =>
    slug = "#{owner}/#{repo}"
    cache = @getCache slug
    return callback null, cache if cache?

    options =
      baseUrl: 'https://api.github.com/'
      uri: "/repos/#{slug}/releases"
      headers:
        'User-Agent': 'Octoblu Connector Detail Service'
        'Authorization': "token #{@githubToken}"
      json: true

    request.get options, (error, response, bodyResponse={}) =>
      return callback @_createError 500, error.message if error?
      return callback @_createError response.statusCode, bodyResponse.message if response.statusCode > 299
      details = {
        owner,
        repo,
        latest: {}
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
      @setCache slug, details
      callback null, details

  setCache: (slug, details) =>
    @cache[slug] ?= {}
    @cache[slug].details = details
    @cache[slug].updatedAt = Date.now()

  getCache: (slug) =>
    return unless @cache[slug]?
    secondsAgo = moment().subtract 30, 'seconds'
    return @cache[slug] if moment(@cache[slug].updatedAt).isBefore secondsAgo

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = GithubDetailService
