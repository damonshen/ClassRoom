socket = (app)->
  io = require('socket.io')(app)
  connectedUser = []
  completedUser = []

  io.on \connection, (socket)->
    console.log io.sockets.sockets.length + ' users'

    # emit count result to all sockets
    refreshCount = ->
      # emit to all sockets
      io.emit \refresh, completedUser.length

    # the user's job is completed
    socket.on \completion, (userName)->
      console.log completedUser
      if userName in completedUser
        console.log userName + ' already connect'
      else
        completedUser.push userName
        console.log \completion
      # emit the result
      refreshCount!

    # remove the information of the user after disconnection
    socket.on \disconnect, ->
      console.log \disconnect


module.exports = socket
