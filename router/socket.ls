socket = (app)->
  io = require('socket.io')(app)
  io.on \connection, (socket)->
    console.log io.sockets.sockets.length
    console.log \connect
    socket.on \disconnect, ->
      console.log \disconnection
    socket.on \completion, (data)->
      console.log \completion

module.exports = socket
