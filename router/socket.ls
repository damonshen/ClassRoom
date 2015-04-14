socket = (app)->
  io = require('socket.io')(app)
  connectedUsers = []
  completedUsers = []
  selectedUsers = {}

  io.on \connection, (socket)->
    console.log io.sockets.sockets.length + ' users'
    # record the connected users
    connectedUsers.push socket.id

    getSelectionCount = ->
      count =
        * a:0
          b:0
          c:0
          d:0

      for k,v of selectedUsers
        count[v]++
      return count
    # emit count result to all sockets
    sendRefreshReq = ->
      # response infomation
      response = {}
      response['completionCount'] = completedUsers.length + '/' + connectedUsers.length
      response['selectionCount'] = getSelectionCount!
      # emit to all sockets
      console.log getSelectionCount!
      io.emit \refresh, response

    # remove the user from completed list.
    removeFromCompletedUsers = (id)->
      if (index = completedUsers.indexOf id) > -1
        completedUsers.splice index,1
      console.log completedUsers

    # remove the user from seleted list.
    removeFromSelectedUsers = (id)->
      delete! selectedUsers[id]
    # send initial status to client
    sendRefreshReq!
    # the user's job is completed
    socket.on \completion, (userName)->
      console.log completedUsers
      if socket.id in completedUsers
        index = completedUsers.indexOf socket.id
        completedUsers.splice index,1
        console.log 'already complete'
      else
        completedUsers.push socket.id
        console.log \completion
      # emit the result
      sendRefreshReq!
    socket.on \selection, (userAnswer)->
      for user of userAnswer
        selectedUsers[socket.id] := userAnswer[user]
      console.log selectedUsers
      console.log socket.id
      sendRefreshReq!

    socket.on \reset, (data)->
      console.log \reset
      # reset the global array
      completedUsers := []
      selectedUsers := {}
      sendRefreshReq!


    # remove the information of the user after disconnection.
    socket.on \disconnect, ->
      # remove the user from connected user list.
      index = connectedUsers.indexOf socket.id
      connectedUsers.splice index,1
      # remove the user from complete and selected user list.
      removeFromCompletedUsers(socket.id)
      removeFromSelectedUsers(socket.id)
      sendRefreshReq!
      console.log \disconnect


module.exports = socket
