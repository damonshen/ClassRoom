socket = (app)->
  io = require('socket.io')(app)
  connectedUser = []
  completedUser = []
  selectionAnswer = {}

  io.on \connection, (socket)->
    console.log io.sockets.sockets.length + ' users'
    getSelectionCount = ->
      count =
        * a:0
          b:0
          c:0
          d:0

      for k,v of selectionAnswer
        count[v]++
      return count
    # emit count result to all sockets
    sendRefreshReq = ->
      # response infomation
      response = {}
      response['completionCount'] = completedUser.length
      response['selectionCount'] = getSelectionCount!
      # emit to all sockets
      console.log getSelectionCount!
      io.emit \refresh, response

    # send initial status to client
    sendRefreshReq!
    # the user's job is completed
    socket.on \completion, (userName)->
      console.log completedUser
      if socket.id in completedUser
        index = completedUser.indexOf socket.id
        console.log typeof socket.id
        console.log socket.id
        console.log index
        completedUser.splice index,1
        console.log socket.id + 'remove '+socket.id + 'from completion list'
      else
        completedUser.push socket.id
        console.log \completion
      # emit the result
      sendRefreshReq!
    socket.on \selection, (userAnswer)->
      for user of userAnswer
        selectionAnswer[socket.id] := userAnswer[user]
      console.log socket.id
      sendRefreshReq!

    socket.on \reset, (data)->
      console.log \reset
      # reset the global array
      completedUser := []
      selectionAnswer := {}
      sendRefreshReq!


    # remove the information of the user after disconnection
    socket.on \disconnect, ->
      if socket.id in completedUser
        index = completedUser.indexOf socket.id
        console.log typeof socket.id
        console.log socket.id
        console.log index
        completedUser.splice index,1
      sendRefreshReq!
      console.log \disconnect


module.exports = socket
