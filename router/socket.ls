socket = (app)->
  io = require('socket.io')(app)
  completedUser = []

  count = ->
    completeCount = Object.keys(completedUser).length
    console.log completeCount
  io.on \connection, (socket)->
    console.log io.sockets.sockets.length + ' users'

    # the user's job is completed
    socket.on \completion, (userName)->
      console.log userName
      if userName in completedUser
        console.log userName + ' already connect'
        count!
      else
        completedUser.push userName
        console.log \completion

    # remove the information of the user after disconnection
    socket.on \disconnect, ->
      console.log \disconnect


module.exports = socket
