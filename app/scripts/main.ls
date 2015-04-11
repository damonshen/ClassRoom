socket = io!
console.log userip

# initialize the chart
$ \#selectionChart .highcharts do
  chart:
    animation: false
    backgroundColor: null
    plotBackgroundColor: null
    plotBorderWidth: null
    plotShadow: false
  title:
    text: 'chart'
  tooltip:
    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
  plotOptions:
    pie:
      animation: false
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: true
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
  series: [
    * type: 'pie'
      name: 'Selection Answer'
      data: [
        ['A',0]
        ['B',0]
        ['C',0]
        ['D',0]
      ]
  ]

# send completion request to server
$ \#completeBtn .click ->
  socket.emit \completion, userip
# reset the count
$ \#resetBtn .click ->
  socket.emit \reset
  $ \.completeValue .html 0
  $ \#countA .html 0
  $ \#countB .html 0
  $ \#countC .html 0
  $ \#countD .html 0


$ '.label input' .change ->
  answer = $ 'input[name=answer]:checked' .val!
  answerRequest = {}
  answerRequest[userip] = answer
  console.log answerRequest
  socket.emit \selection, answerRequest
# get the new count from server and refresh DOM
socket.on \refresh, (data)->
  console.log data
  completionCount = data['completionCount']
  selectionCount = data['selectionCount']
  console.log getChartSeries selectionCount
  dataSeries = getChartSeries selectionCount
  # update the count value
  $ \#countA .html selectionCount.a
  $ \#countB .html selectionCount.b
  $ \#countC .html selectionCount.c
  $ \#countD .html selectionCount.d
  refreshCount completionCount, dataSeries

getChartSeries = (selectionObj)->
  series = []
  for k,v of selectionObj
    series.push [k.toUpperCase!,v]
  return series

refreshCount = (completionCount, selectionSeries)->
  $ \.completeValue .html completionCount
  $ \#selectionChart .highcharts do
    chart:
      animation: false
      backgroundColor: null
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
    title:
      text: 'chart'
    tooltip:
      pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions:
      pie:
        animation: false
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: true
          format: '<b>{point.name}</b>: {point.percentage:.1f} %'
    series: [
      * type: 'pie'
        name: 'Selection Answer'
        data: selectionSeries
    ]

