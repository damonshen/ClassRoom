// Generated by LiveScript 1.3.1
(function(){
  var socket;
  socket = function(app){
    var io, connectedUser, completedUser, selectionAnswer;
    io = require('socket.io')(app);
    connectedUser = [];
    completedUser = [];
    selectionAnswer = {};
    return io.on('connection', function(socket){
      var getSelectionCount, sendRefreshReq;
      console.log(io.sockets.sockets.length + ' users');
      getSelectionCount = function(){
        var count, k, ref$, v;
        count = {
          a: 0,
          b: 0,
          c: 0,
          d: 0
        };
        for (k in ref$ = selectionAnswer) {
          v = ref$[k];
          count[v]++;
        }
        return count;
      };
      sendRefreshReq = function(){
        var response;
        response = {};
        response['completionCount'] = completedUser.length;
        response['selectionCount'] = getSelectionCount();
        console.log(getSelectionCount());
        return io.emit('refresh', response);
      };
      sendRefreshReq();
      socket.on('completion', function(userName){
        console.log(completedUser);
        if (in$(socket.id, completedUser)) {
          console.log(socket.id + ' already connect');
        } else {
          completedUser.push(socket.id);
          console.log('completion');
        }
        return sendRefreshReq();
      });
      socket.on('selection', function(userAnswer){
        var user;
        for (user in userAnswer) {
          selectionAnswer[socket.id] = userAnswer[user];
        }
        console.log(socket.id);
        return sendRefreshReq();
      });
      socket.on('reset', function(data){
        console.log('reset');
        completedUser = [];
        selectionAnswer = {};
        return sendRefreshReq();
      });
      return socket.on('disconnect', function(){
        return console.log('disconnect');
      });
    });
  };
  module.exports = socket;
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
}).call(this);
