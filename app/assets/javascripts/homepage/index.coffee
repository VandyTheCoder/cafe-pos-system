CafePOS.HomepageIndex =
  init: ->
    @_fetchDailySaleData()
    @_handleDialySaleFilter()
  
  _fetchDailySaleData: ->
    boss = @
    filter_month = $('#filter-data').data 'filtered-month'
    filter_year = $('#filter-data').data 'filtered-year'
    ajax = $.ajax
      url: '/chart_data?month=' + filter_month + '&year=' + filter_year
      type: 'GET'
      success: (data) ->
        boss.initDashboardChart(data)
      error: (error) ->
        console.log(error)
  
  _handleDialySaleFilter: ->
    boss = @
    root_url = $('#filter-data').data 'url'
    $("#sales-filter").change (e) ->
      value = $(this).val().split('-')
      month = value[0]
      year = value[1]
      window.location.href = "#{root_url}?month=#{month}&year=#{year}"
  
  initDashboardChart: (data) ->
    boss = @
    chart = 
      series: [
        {
          name: 'Earnings this month:',
          data: data.amounts
        }
      ]
      chart:
        type: 'bar'
        height: 345
        offsetX: -15
        toolbar: show: true
        foreColor: '#adb0bb'
        fontFamily: 'inherit'
        sparkline: enabled: false
      colors: [
        '#5D87FF'
        '#49BEFF'
      ]
      plotOptions: bar:
        horizontal: false
        columnWidth: '35%'
        borderRadius: [ 6 ]
        borderRadiusApplication: 'end'
        borderRadiusWhenStacked: 'all'
      markers: size: 0
      dataLabels: enabled: false
      legend: show: false
      grid:
        borderColor: 'rgba(0,0,0,0.1)'
        strokeDashArray: 3
        xaxis: lines: show: false
      xaxis:
        type: 'category',
        categories: data.dates,
        labels: style: cssClass: 'grey--text lighten-2--text fill-color'
      yaxis:
        show: true
        min: 0
        max: data.highest_amount + 100
        tickAmount: 4
        labels: style: cssClass: 'grey--text lighten-2--text fill-color'
      stroke:
        show: true
        width: 3
        lineCap: 'butt'
        colors: [ 'transparent' ]
      tooltip: theme: 'light'
      responsive: [ {
        breakpoint: 600
        options: plotOptions: bar: borderRadius: 3
      } ]
    chart = new ApexCharts(document.querySelector('#chart'), chart)
    chart.render()
    # =====================================
    # Breakup
    # =====================================
    breakup = 
      color: '#adb5bd'
      series: data.yearly_sales
      labels: data.yearly_labels
      chart:
        width: 180
        type: 'donut'
        fontFamily: 'Plus Jakarta Sans\', sans-serif'
        foreColor: '#adb0bb'
      plotOptions: pie:
        startAngle: 0
        endAngle: 360
        donut: size: '75%'
      stroke: show: false
      dataLabels: enabled: false
      legend: show: false
      colors: [
        '#5D87FF'
        '#ecf2ff'
        '#F9F9FD'
      ]
      responsive: [ {
        breakpoint: 991
        options: chart: width: 150
      } ]
      tooltip:
        theme: 'dark'
        fillSeriesColor: false
    chart = new ApexCharts(document.querySelector('#breakup'), breakup)
    chart.render()
    # =====================================
    # Earning
    # =====================================
    earning = 
      chart:
        id: 'sparkline3'
        type: 'area'
        height: 60
        sparkline: enabled: true
        group: 'sparklines'
        fontFamily: 'Plus Jakarta Sans\', sans-serif'
        foreColor: '#adb0bb'
      series: [ {
        name: 'Earnings'
        color: '#49BEFF'
        data: data.monthly_sales
      } ]
      stroke:
        curve: 'smooth'
        width: 2
      fill:
        colors: [ '#f3feff' ]
        type: 'solid'
        opacity: 0.05
      markers: size: 0
      tooltip:
        theme: 'dark'
        fixed:
          enabled: true
          position: 'right'
        x: show: false
    new ApexCharts(document.querySelector('#earning'), earning).render()
    return