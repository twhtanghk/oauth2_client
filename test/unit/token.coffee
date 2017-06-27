util = require 'util'
assert = require 'assert'
oauth2 = require '../../index.coffee'

[
  'TOKENURL'
  'VERIFYURL'
  'USER_ID'
  'USER_SECRET'
  'CLIENT_ID'
  'CLIENT_SECRET'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

describe 'oauth2', ->
  it 'resource owner password credentials grant', ->
    oauth2
      .token process.env.TOKENURL, clients[0], user, scope
      .then (token) ->
        oauth2.verify process.env.VERIFYURL, scope, token
      .then console.log

  it 'client credentials grant', ->
    oauth2
      .token process.env.TOKENURL, clients[1]
      .then (token) ->
        oauth2.verify process.env.VERIFYURL, scope, token
      .then console.log
