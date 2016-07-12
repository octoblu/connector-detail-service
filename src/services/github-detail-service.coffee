_       = require 'lodash'
request = require 'request'
debug   = require('debug')('connector-detail-service:github-detail-service')

class GithubDetailService
  constructor: ({ @githubToken }) ->

  getDetails: ({ owner, repo }, callback) =>
    slug = "#{owner}/#{repo}"
    @getReleases { slug }, (userError, rawReleases) =>
      return callback userError if userError?
      @getLatestRelease { slug }, (userError, rawLatest) =>
        return callback userError if userError?
        latest = @getTagInfo rawLatest
        tags = @getTagsFromReleases rawReleases
        callback null, {
          owner,
          repo,
          latest,
          tags,
        }

  getTagsFromReleases: (releases) =>
    tagValues = _.map releases, @getTagInfo
    tagKeys = _.map tagValues, 'tag'
    return _.zipObject tagKeys, tagValues

  getTagInfo: ({ tag_name, created_at, published_at, assets, prerelease, draft }) =>
    return {
      tag: tag_name,
      created_at,
      published_at,
      prerelease,
      draft,
      assets: _.map(assets, 'name')
    }

  getReleases: ({ slug }, callback) =>
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
      return callback null, bodyResponse

  getLatestRelease: ({ slug }, callback) =>
    options =
      baseUrl: 'https://api.github.com/'
      uri: "/repos/#{slug}/releases/latest"
      headers:
        'User-Agent': 'Octoblu Connector Detail Service'
        'Authorization': "token #{@githubToken}"
      json: true

    request.get options, (error, response, bodyResponse={}) =>
      return callback @_createError 500, error.message if error?
      return callback @_createError response.statusCode, bodyResponse.message if response.statusCode > 299
      return callback null, bodyResponse

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = GithubDetailService
