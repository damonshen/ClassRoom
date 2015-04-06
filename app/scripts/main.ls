socket = io!
console.log userip
$ \button .click ->
  socket.emit \completion, userip

socket.on \refresh, (data)->
  console.log \result + data
  $ \.completeValue .html data


refreshCount = ->
  # refresh complete count
