socket = io!
console.log userip
$ \#completeBtn .click ->
  socket.emit \completion, userip

$ '.label input' .change ->
  answer = $ 'input[name=answer]:checked' .val!
  answerRequest = {}
  answerRequest[userip] = answer
  console.log answerRequest
  socket.emit \selection, answerRequest
socket.on \refresh, (data)->
  console.log data
  completionCount = data['completionCount']
  selectionCount = data['selectionCount']
  # update the count value
  $ \.completeValue .html completionCount
  $ \#countA .html selectionCount.a
  $ \#countB .html selectionCount.b
  $ \#countC .html selectionCount.c
  $ \#countD .html selectionCount.d


refreshCount = ->
  # refresh complete count
