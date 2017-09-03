class DashboardView
  constructor: ->
    @generate_by_day()
    @generate_by_months()
    @generate_by_category()
    @generate_accumulated()

  generate_by_months: ->
    months_data = $('#expenses-chart').data('chart')
    new CanvasJS.Chart('expenses-chart', {
      backgroundColor: "#333333"
      animationEnabled: true 
      animationDuration: 1000
      toolTip: {
        fontWeight: "bold"
        shared: true
        backgroundColor: "#666666"
      }
      axisX: {
        labelFontSize: 14.5
        labelFontColor: "white"
      }
      axisY: {
        labelFontSize: 13.5
        labelFontColor: "white"
      }
      data: months_data
    }).render()

  generate_by_day: ->
    CanvasJS.addColorSet('typeColors', ["#cc0000", "#ff6600", "#e69900", "#ffd11a"])
    day_data = $('#daily-expenses-chart').data('chart')
    new CanvasJS.Chart('daily-expenses-chart', {
      backgroundColor: "#333333"
      colorSet: 'typeColors'
      animationEnabled: true 
      animationDuration: 1000
      zoomEnabled: true
      legend: {
        fontSize: 14
        fontColor: "white"
      }
      toolTip: { 
        backgroundColor: "#666666"
        fontWeight: "bold"
        shared: true    
      }
      axisX: {
        labelFontSize: 14.5
        labelFontColor: "white"
      }
      axisY: {
        labelFontSize: 13.5
        labelFontColor: "white"
      }
      data: day_data
    }).render()

  generate_by_category: ->
    category_data = $('#category-chart').data('chart')
    new CanvasJS.Chart('category-chart', {
      backgroundColor: "#333333"
      animationEnabled: true 
      animationDuration: 1000
      toolTip: {   
        content: "{indexLabel} - {y} Expenses"      
      }
      data: [{
        indexLabelFontSize: 15
        indexLabelFontColor: "white"
        highlightEnabled: false
        type: "doughnut"
        dataPoints: category_data
      }]
    }).render()

  generate_accumulated: ->
    accumulated_data = $('#month-acc').data('chart')
    new CanvasJS.Chart('month-acc', {
      backgroundColor: "#333333"
      animationEnabled: true 
      animationDuration: 1000
      legend: {
        fontSize: 14
        fontColor: "white"
      }
      axisX: {
        labelFontSize: 14.5
        labelFontColor: "white"
      }
      axisY: {
        labelFontSize: 13.5
        labelFontColor: "white"
      }
      data: accumulated_data
    }).render()

window.DashboardView = DashboardView