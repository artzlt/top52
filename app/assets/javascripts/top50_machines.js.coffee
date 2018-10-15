COLORS = ["red", "green", "blue", "orange", "purple"]

@test_fun = (text) ->
  console.log("AAAAAAAAAAAAAAAAAAAAAAA" + text)

@draw_perfomance = (data, src_id, title) ->
  for i in [0..data.length - 1]
    #need for normal render, delete in prod
    data[i].data.splice(23, 1)
    #-------------------------
    data[i].color = i
    for j in [0..data[i].data.length - 1]
      s = data[i].data[j][0].split(".")
      data[i].data[j][0] = new Date(+s[2], +s[1], +s[0])
      data[i].data[j][1] = +data[i].data[j][1]

  console.log(data)

  func = () ->
    width = document.getElementById(src_id).offsetWidth
    height = 500

    margin =
      top : 10
      bottom : 50
      right : 10
      left : 50

    container = d3.selectAll("div").filter(() -> d3.select(this).attr("id") == src_id)
            
    container.append("div")
              .text(title)
              .style("font-family", "Arial")
              .style("font-size", "24px")
              .style("border-radius", "7px")
              .style("font-weight", "500")
              .style("padding", "20px  0px")
              .style("line-height", "25px")
              .style("text-align", "center")
              .style("float", "center")

    legend = add_legend(container, data)

    log_button = container.append("div")
              .text("log")
              .attr("active", 0)
              .style("color", "white")
              .style("font-family", "Arial")
              .style("font-size", "14px")
              .style("border-radius", "7px")
              .style("font-weight", "600")
              .style("text-align", "center")
              .style("padding", "4px  10px")
              .style("opacity", "0.9")
              .style("float", "right")
              .style("background", "gray")

    bar_button = container.append("div")
              .text("bar")
              .attr("active", 0)
              .style("color", "white")
              .style("font-family", "Arial")
              .style("font-size", "14px")
              .style("border-radius", "7px")
              .style("font-weight", "600")
              .style("text-align", "center")
              .style("padding", "4px  10px")
              .style("opacity", "0.9")
              .style("float", "right")
              .style("background", "gray")

    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    add_legend_events(legend, svg, container, data, add_line_chart, margin, width, height)
    add_line_chart(svg, container, data, margin, width, height)
    add_axes(svg, data, margin, width, height)


    log_button.on("click", () ->
      temp = []
      for x, i in data
        temp.push({})
        temp[i].name = x.name
        temp[i].color = x.color
        temp[i].data = []
        for y in x.data
          temp[i].data.push([y[0], y[1]])

      d3.select(this).attr("active", (+d3.select(this).attr("active") + 1) % 2)
        .style("background", () -> 
          if +d3.select(this).attr("active")
            return "violet"
          return "gray"
        )
      if +d3.select(this).attr("active")
        bar_button.attr("active", 0).style("background", "gray")
        for x in temp
          x.data = x.data.map((d) -> [d[0], Math.log(1 + d[1])])

      console.log(temp)
      svg.selectAll("g")
          .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
          .transition()
          .duration(500)
          .style("opacity", "0")
          .remove()

      legend.selectAll("div")
            .style("background", () -> COLORS[+d3.select(this).attr("number")])
            .attr("active", 1)

      add_legend_events(legend, svg, container, temp, add_line_chart, margin, width, height)
      add_line_chart(svg, container, temp, margin, width, height)       
      add_axes(svg, temp, margin, width, height)
    )

    bar_button.on("click", () ->
      temp = []
      for x, i in data
        temp.push({})
        temp[i].name = x.name
        temp[i].color = x.color
        temp[i].data = []
        for y in x.data
          temp[i].data.push([y[0], y[1]])

      d3.select(this).attr("active", (+d3.select(this).attr("active") + 1) % 2)
        .style("background", () -> 
          if +d3.select(this).attr("active")
            return "lightblue"
          return "gray"
        )

      svg.selectAll("g")
          .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
          .transition()
          .duration(500)
          .style("opacity", "0")
          .remove()

      legend.selectAll("div")
            .style("background", () -> COLORS[+d3.select(this).attr("number")])
            .attr("active", 1)

      if +d3.select(this).attr("active")
        log_button.attr("active", 0).style("background", "gray")

        bar_data = [{"data" : []}]
        for i in [0..data[0].data.length - 1]
          bar_data[0].data.push([data[0].data[i][0], 0])
          for j in [0..data.length - 1]
            bar_data[0].data[i][1] += data[j].data[i][1]

        add_legend_events(legend, svg, container, temp, add_bar_chart, margin, width, height)
        add_bar_chart(svg, container, temp, margin, width, height)
        add_axes(svg, bar_data, margin, width, height)
      else
        add_legend_events(legend, svg, container, temp, add_line_chart, margin, width, height)
        add_line_chart(svg, container, temp, margin, width, height)       
        add_axes(svg, temp, margin, width, height)
    )


  oldonload = window.onload;
  if typeof(window.onload) != "function"
    window.onload = func
  else
    window.onload = () ->
      if (oldonload)
        oldonload()
      func()
  return 0

add_legend = (container, data) ->
  legend = container.append("g").attr("id", "legend")

  for set, i in data
    legend.append("div")
          .style("background", COLORS[i])
          .text(data[i].name)
          .attr("active", 1)
          .attr("number", i)
          .style("color", "white")
          .style("font-family", "Arial")
          .style("font-size", "14px")
          .style("border-radius", "7px")
          .style("font-weight", "600")
          .style("text-align", "center")
          .style("padding", "4px  10px")
          .style("opacity", "0.9")
          .style("float", "left")

  return legend

add_legend_events = (legend, svg, container, data, construct, margin, width, height) ->
  legend.selectAll("div")
    .on("click", () ->
          d3.select(this).attr("active", (+d3.select(this).attr("active") + 1) % 2)
            .transition()
            .duration(500)
            .style("background", () -> 
              if +d3.select(this).attr("active")
                return COLORS[+d3.select(this).attr("number")]
              return "gray"
            )
          temp = []
          legend.selectAll("div")
                .filter(() -> +d3.select(this).attr("active"))
                .each(() -> temp.push(data[+d3.select(this).attr("number")]))

          svg.selectAll("g")
              .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
              .transition()
              .duration(500)
              .style("opacity", "0")
              .remove()

          add_axes(svg, temp, margin, width, height)
          construct(svg, container, temp, margin, width, height)
    )


add_axes = (svg, data, margin, width, height) ->
  xScale = d3.scaleTime()
            .domain([data[0].data[0][0], data[0].data[data[0].data.length - 1][0]])
            .range([margin.left, width - margin.right])

  temp = []
  dates = data[0].data.map((d) -> d[0])
  for line in data
    temp = temp.concat(line.data.map((d) -> +d[1]))

  yScale = d3.scaleLinear()
              .domain([0, d3.max(temp)])
              .range([height - margin.bottom, margin.top])

  axes = svg.append("g").attr("id", "axes")

  xAxis = axes.append("g")
    .attr("id", "x_axis")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(xScale).tickValues(dates).tickFormat(d3.timeFormat("%m.%y")).tickSize(7))

  xAxis.selectAll("text")
      .attr("text-anchor", "end")
      .attr("dx", "-.6em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-55)")
      .style("font-family", "Arial")
      .style("font-size", "14px")
      .style("font-weight", "500")

  yAxis = axes.append("g")
          .attr("id", "y_axis")
          .attr("transform", "translate(0,0)")
          .call(d3.axisLeft(yScale).tickSize(-width + margin.left + margin.right).tickPadding(8))

  yAxis.selectAll("text")
      .style("font-family", "Arial")
      .style("font-size", "14px")
      .style("font-weight", "500")

  yAxis.selectAll("line")
      .style("opacity", "0.2")
      .attr("dashoffset", 0)
      .style("stroke-dasharray", "0 0")

  yAxis.selectAll("path")
      .style("opacity", "0.2")

  xAxis.transition()
      .duration(1000)
      .ease(d3.easeLinear)
      .attr("transform", "translate(0," + (height - margin.bottom) + ")")
  yAxis.transition()
      .duration(1000)
      .ease(d3.easeLinear)
      .attr("transform", "translate(" + margin.left + "," + 0 + ")")
      .selectAll("line")
      .attr("dashoffset", 10)
      .style("stroke-dasharray", "7 5")
  return axes

add_line_chart = (svg, container, data, margin, width, height) ->
  xScale = d3.scaleTime()
            .domain([data[0].data[0][0], data[0].data[data[0].data.length - 1][0]])
            .range([margin.left, width - margin.right])

  temp = []
  for line in data
    temp = temp.concat(line.data.map((d) -> +d[1]))

  yScale = d3.scaleLinear()
              .domain([0, d3.max(temp)])
              .range([height - margin.bottom, margin.top])

  chart = svg.append("g").attr("id", "chart")
  
  line = d3.line()
            .x((d) -> xScale(d[0]))
            .y((d) -> yScale(d[1]))
            .curve(d3.curveMonotoneX)

  for set, i in data
    g = chart.append("g").attr("id", "line" + i)

    path = g.append("path")
      .attr("d", line(set.data))
      .style("stroke", COLORS[set.color])
      .style("stroke-width", 3)
      .attr("fill", "none")

    g.append("g")
      .attr("id", "circles")
      .selectAll("circle")
      .data(set.data)
      .enter()
      .append("circle")
      .attr("r", 0)
      .attr("color", set.color)
      .attr("cx", (d) -> xScale(d[0]))
      .attr("cy", (d) -> yScale(d[1]))
      .attr("value", (d) -> Math.round(d[1] * 100) / 100)
      .style("fill", COLORS[set.color])
      .transition()
      .ease(d3.easeElastic)
      .delay((d, i) -> i * 40 + 500)
      .duration(500)
      .attr("r", 5)

    len = path.node().getTotalLength()
    path.attr("stroke-dasharray", len + " " + len)
        .attr("stroke-dashoffset", len)
        .transition()
        .duration(1000)
        .ease(d3.easeLinear)
        .attr("stroke-width", 6)
        .attr("stroke-dashoffset", 0)


  tooltip = container.append("div")
              .attr("id", "tooltip_" + container.attr("id"))
              .style("opacity", 0)
              .style("position", "fixed")
              .style("padding", "2px 10px")
              .style("color", "white")
              .style("border-radius", "7px 7px 0px 7px")
              .style("font-family", "Arial")
              .style("font-size", "14px")
              .style("font-weight", "600")
              .style("float", "right")

  svg.selectAll("circle")
    .on("mouseover", () ->
        elem = d3.select(this)
        svg.selectAll("circle")
            .filter(() -> d3.select(this).attr("cx") == elem.attr("cx"))
            .transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .attr("r", 8)
            .style("fill", "white")
            .style("stroke", () -> COLORS[d3.select(this).attr("color")])
            .style("stroke-width", 3)
        svg.selectAll("circle")
            .filter(() -> d3.select(this).attr("cx") != elem.attr("cx"))
            .transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .attr("r", 3)

        left = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().left - document.getElementById("tooltip_" + container.attr("id")).offsetWidth - 10
        top = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().top - document.getElementById("tooltip_" + container.attr("id")).offsetHeight - 10
        tooltip.transition()
              .duration(300)
              .ease(d3.easeElastic)
              .style("opacity", 0.9)
              .style("background", COLORS[d3.select(this).attr("color")])
              .text(elem.attr("value"))
              .style("left", (+elem.attr("cx") + left) + "px")
              .style("top", (+elem.attr("cy") + top) + "px")
    )
    .on("mouseout", () ->
        xcord = d3.select(this).attr("cx");
        svg.selectAll("circle")
            .transition()
            .duration(2000)
            .ease(d3.easeElastic)
            .attr("r", 5)
            .style("fill", () -> COLORS[d3.select(this).attr("color")])
            .style("stroke-width", 0)

        tooltip.transition()
            .duration(300)
            .ease(d3.easeElastic)
            .style("opacity", 0)
            .style("top", "0px")
    )
  return chart

add_bar_chart = (svg, container, data, margin, width, height) ->
  xScale = d3.scaleTime()
            .domain([data[0].data[0][0], data[0].data[data[0].data.length - 1][0]])
            .range([margin.left, width - margin.right])

  stack = d3.stack()
            .keys([0..data.length - 1])

  bar_data = []
  for i in [0..data[0].data.length - 1]
    bar_data.push({"date" : data[0].data[i][0]})
    for j in [0..data.length - 1]
      bar_data[i][j] = data[j].data[i][1]

  bar_data = stack(bar_data)
  console.log(bar_data)

  yScale = d3.scaleLinear()
              .domain([0, bar_data[bar_data.length - 1][bar_data[bar_data.length - 1].length - 1][1]])
              .range([height - margin.bottom, margin.top])

  loc_colors = data.map((d) -> d.color)

  chart = svg.append("g").attr("id", "chart")

  chart.selectAll("g")
        .data(bar_data)
        .enter()
        .append("g")
        .style("fill", (d, i) -> COLORS[loc_colors[i]])
        .selectAll("rect")
        .data((d) -> d)
        .enter()
        .append("rect")
        .attr("value", (d) -> Math.round((d[1] - d[0]) * 100) / 100)
        .attr("x", (d) -> xScale(d.data.date) - 10)
        .attr("width", 20)
        .attr("rx", 4)
        .attr("ry", 4)
        .attr("y", height - margin.bottom)
        .transition()
        .duration(1000)
        .ease(d3.easeLinear)
        .attr("y", (d) -> yScale(d[1]))
        .attr("height", (d) -> yScale(d[0]) - yScale(d[1]))

  tooltip = container.append("div")
                    .attr("id", "tooltip_" + container.attr("id"))
                    .style("opacity", 0)
                    .style("position", "absolute")
                    .style("padding", "2px 10px")
                    .style("color", "white")
                    .style("border-radius", "7px 7px 0px 7px")
                    .style("font-family", "Arial")
                    .style("font-size", "14px")
                    .style("font-weight", "600")
                    .style("float", "right")
                    .style("border-style", "solid")
                    .style("border-width", "3px")
                    .style("border-color", "whit")

  svg.selectAll("rect")
    .on("mouseover", () ->
        elem = d3.select(this)

        elem.transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .style("stroke", () -> d3.select(this.parentNode).style("fill"))
            .style("stroke-width", 5)
            .attr("width", 26)
            .attr("x", (d) -> xScale(d.data.date) - 13)
            .attr("height", (d) -> yScale(d[0]) - yScale(d[1]) + 6)
            .attr("y", (d) -> yScale(d[1]) - 3)

        svg.selectAll("rect")
            .filter(() -> d3.select(this).attr("x") != elem.attr("x") || d3.select(this).attr("y") != elem.attr("y"))
            .transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .attr("width", 16)
            .attr("x", (d) -> xScale(d.data.date) - 8)

        left = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().left - document.getElementById("tooltip_" + container.attr("id")).offsetWidth + 5
        top = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().top - document.getElementById("tooltip_" + container.attr("id")).offsetHeight + 5
        tooltip.transition()
              .duration(300)
              .ease(d3.easeElastic)
              .style("opacity", 1)
              .style("background", elem.style("fill"))
              .text(elem.attr("value"))
              .style("left", (+elem.attr("x") + left) + "px")
              .style("top", (+elem.attr("y") + top) + "px")
        console.log(+elem.attr("y") + top)
    )
    .on("mouseout", () ->
        xcord = d3.select(this).attr("cx");
        svg.selectAll("rect")
            .transition()
            .duration(2000)
            .ease(d3.easeElastic)
            .style("fill", () -> d3.select(this.parentNode).attr("color"))
            .style("stroke-width", 0)
            .attr("width", 20)
            .attr("height", (d) -> yScale(d[0]) - yScale(d[1]))
            .attr("x", (d) -> xScale(d.data.date) - 10)
            .attr("y", (d) -> yScale(d[1]))

        tooltip.transition()
            .duration(300)
            .ease(d3.easeElastic)
            .style("opacity", 0)
            .style("top", "0px")
    )
  return chart


$ ->
  $("#add-form-link").click ->	
    onstr = "Показать поля ввода"
    offstr = "Скрыть поля ввода"
    $(this).text(if $(this).text() == onstr then offstr else onstr)
    $("#just-text").toggle()
    $("#form-new_machine").toggle()

  $("#top50_machine_org_id").change ->
    org_id = $(this).val()
    url = "/top50_organizations/#{org_id}/suborgs"
    select = $("#top50_machine_top50_organization_sub_org_id")
    select.select2("val", "")
    select.data("source", url)
    reinit_select2(select)

  reinit_select2 = (el) ->
    select = $(el)
    options = select.find("option")
    $(options[0]).select()  if options.size() is 1
    options =
      placeholder: select2_localization[window.locale]
      allowClear: true

    options.ajax =
      url: select.data("source")
      dataType: "json"
      quietMillis: 100
      data: (term, page) ->
        q: $.trim(term)
        page: page
        per: 10

      results: (data, page) ->
        more = undefined
        more = (page * 10) < data.total
        results: data.records
        more: more
    options.dropdownCssClass = "bigdrop"
    options.initSelection = (element, callback) ->
      if element.val().length > 0
        $.getJSON select.data("source") + "/" + element.val(), {}, (data) ->
          callback
            id: data.id
            text: data.text

    select.select2 options
