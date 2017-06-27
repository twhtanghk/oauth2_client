_ = require 'lodash'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'

module.exports =
  # 1. get token for Resource Owner Password Credentials Grant
  #   url: authorization server url to get token
  #   client:
  #     id: registered client id
  #     secret: client secret
  #   user:
  #     id: registered user id
  #     secret: user password
  #   scope: [ "User", "Mobile"]
  # 2. get token for Client Credentials Grant
  #   url: authroization server url to get token
  #   client:
  #     id: registered client id
  #     secret: client secret
  token: (url, client, user = null, scope = null) ->
    opts =
      'Content-Type': 'application/x-www-form-urlencoded'
      username: client.id
      password: client.secret
    data = {}
    if user?
      data =
        grant_type: 'password'
        username: user.id
        password: user.secret
        scope: scope.join(' ')
    else
      data =
        grant_type: 'client_credentials'
    needle
      .postAsync url, data, opts
      .then (res) ->
        res.body.access_token

  # verify specified token
  # url: authorization server url to verify token
  # scope: required scope
  # token: token to be verified
  # return: promise to resolve token details
  verify: (url, scope, token) ->
    opts =
      headers:
        Authorization: "Bearer #{token}"
    needle
      .getAsync url, opts
      .then (res) ->
        if res.statusCode != 200
          return Promise.reject res.body
        authScope = res.body.scope.split ' '
        result = _.intersection scope, authScope 
        if result.length != scope.length
          Promise.reject "Unathorizated access to #{scope}"
        res.body
