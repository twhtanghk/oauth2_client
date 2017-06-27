_ = require 'lodash'
assert = require 'assert'

[
  'USER_ID'
  'USER_SECRET'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'TOKENURL'
  'VERIFYURL'
  'SCOPE'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

before ->
  clients =
    id: process.env.CLIENT_ID.split ','
    secret: process.env.CLIENT_SECRET.split ','
  global.clients = _.map clients.id, (id, index) ->
    id: id
    secret: clients.secret[index]
  global.user =
    id: process.env.USER_ID
    secret: process.env.USER_SECRET
  global.scope = process.env.SCOPE.split ' '
