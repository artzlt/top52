COLORS = ["red", "green", "blue", "orange", "purple"]

@test_fun = (text) ->
  #dsdfgdsfsa
  console.log("AAAAAAAAAAAAAAAAAAAAAAA" + text)

@draw_perfomance = (data, src_id, title, x_label, y_label) ->
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
    height = 550

    margin =
      top : 10
      bottom : 80
      right : 10
      left : 80

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

    buttons = container.append("g").attr("id", "buttons")


    line_button = buttons.append("div")
              .text("line")
              .attr("class", "button")
              .style("background", "#6699CC")
              .style("float", "right")
              .attr("name", "type")
              .property("checked", "true")

    log_button = buttons.append("div")
              .text("log")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .property("checked", "false")

    bar_button = buttons.append("div")
              .text("bar")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .property("checked", "false")

    table_control = d3.selectAll("g").filter(() -> d3.select(this).attr("id") == "table_control_" + src_id)
    mode = [true, false, false]
    table = d3.selectAll("table").filter(() -> d3.select(this).attr("id") == "table_" + src_id)
    table_control.selectAll("div").filter(() -> d3.select(this).attr("id") == "0")
                .property("checked", true)
                .each(() -> console.log(d3.select(this).property("checked")))
    table_control.selectAll("div").filter(() -> d3.select(this).attr("id") == "1")
                .property("checked", false)
                .each(() -> console.log(d3.select(this).property("checked")))
    table_control.selectAll("div").filter(() -> d3.select(this).attr("id") == "2")
                .property("checked", false)
                .each(() -> console.log(d3.select(this).property("checked")))

    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    add_legend_events(legend, svg, container, data, add_line_chart, margin, width, height, x_label, y_label)
    add_axes(svg, data, margin, width, height, x_label, y_label)
    add_line_chart(svg, container, data, margin, width, height)


    line_button.on("click", () ->
      buttons.selectAll("div[name='type']").each(() ->
        if d3.select(this).property("checked")
          d3.select(this)
            .transition()
            .ease(d3.easeLinear)
            .duration(500)
            .style("background", "gray")
      )
      if d3.select(this).property("checked")
        d3.select(this)
          .transition()
          .ease(d3.easeLinear)
          .duration(500)
          .style("background", "#6699CC")

        svg.selectAll("g")
            .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
            .transition()
            .duration(500)
            .style("opacity", "0")
            .remove()

        data_to_draw = []
        legend.selectAll("div")
                .filter(() -> +d3.select(this).attr("active"))
                .each(() -> data_to_draw.push(data[+d3.select(this).attr("number")]))

        add_legend_events(legend, svg, container, data, add_line_chart, margin, width, height, x_label, y_label)
        add_axes(svg, data_to_draw, margin, width, height, x_label, y_label)
        add_line_chart(svg, container, data_to_draw, margin, width, height)       
    )

    log_button.on("click", () ->
      buttons.selectAll("div[name='type']").each(() ->
        if d3.select(this).property("checked")
          d3.select(this)
            .transition()
            .ease(d3.easeLinear)
            .duration(500)
            .style("background", "gray")
      )
      if d3.select(this).property("checked")
        temp = []
        for x, i in data
          temp.push({})
          temp[i].name = x.name
          temp[i].color = x.color
          temp[i].data = []
          for y in x.data
            temp[i].data.push([y[0], y[1]])

        d3.select(this)
          .transition()
          .ease(d3.easeLinear)
          .duration(500)
          .style("background", "#6699CC")

        for x in temp
          x.data = x.data.map((d) -> [d[0], Math.log(1 + d[1])])

        console.log(temp)
        svg.selectAll("g")
            .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
            .transition()
            .duration(500)
            .style("opacity", "0")
            .remove()

        data_to_draw = []
        legend.selectAll("div")
                .filter(() -> +d3.select(this).attr("active"))
                .each(() -> data_to_draw.push(temp[+d3.select(this).attr("number")]))

        add_legend_events(legend, svg, container, temp, add_line_chart, margin, width, height, x_label)
        add_axes(svg, data_to_draw, margin, width, height, x_label)
        add_line_chart(svg, container, data_to_draw, margin, width, height)       
    )

    bar_button.on("click", () ->
      buttons.selectAll("div[name='type']").each(() ->
        if d3.select(this).property("checked")
          d3.select(this)
            .transition()
            .ease(d3.easeLinear)
            .duration(500)
            .style("background", "gray")
      )
      if d3.select(this).property("checked")
        temp = []
        for x, i in data
          temp.push({})
          temp[i].name = x.name
          temp[i].color = x.color
          temp[i].data = []
          for y in x.data
            temp[i].data.push([y[0], y[1]])

        d3.select(this)
          .transition()
          .ease(d3.easeLinear)
          .duration(500)
          .style("background", "#6699CC")

        svg.selectAll("g")
            .filter(() -> d3.select(this).attr("id") == "chart" || d3.select(this).attr("id") == "axes")
            .transition()
            .duration(500)
            .style("opacity", "0")
            .remove()

        data_to_draw = []
        legend.selectAll("div")
                .filter(() -> +d3.select(this).attr("active"))
                .each(() -> data_to_draw.push(temp[+d3.select(this).attr("number")]))

        bar_data = [{"data" : []}]
        for i in [0..data_to_draw[0].data.length - 1]
          bar_data[0].data.push([data[0].data[i][0], 0])
          for j in [0..data_to_draw.length - 1]
            bar_data[0].data[i][1] += data_to_draw[j].data[i][1]

        add_legend_events(legend, svg, container, temp, add_bar_chart, margin, width, height, x_label, y_label)
        add_axes(svg, bar_data, margin, width, height, x_label, y_label)
        add_bar_chart(svg, container, data_to_draw, margin, width, height)
    )

    table_control.selectAll("div").on("click", (d, i) ->
      d3.select(this).property("checked", !d3.select(this).property("checked"))
      mode[i] = d3.select(this).property("checked")
      console.log(mode)
      if d3.select(this).property("checked")
        d3.select(this)
          .transition()
          .ease(d3.easeLinear)
          .duration(500)
          .style("background", "#6699CC")
      else
        d3.select(this)
          .transition()
          .ease(d3.easeLinear)
          .duration(500)
          .style("background", "gray")
    )

    table_control.on("click", () ->
      console.log("table control")
      table.selectAll("td")
            .filter(() -> d3.select(this).attr("class") != "fit")
            .each(() ->
              elem = d3.select(this)
              i = +elem.attr("i")
              j = +elem.attr("j")
              val = +elem.attr("value")
              find_j = j
              if !(j % 2) then find_j = j + 1
              next = table.selectAll("td").filter(() -> +d3.select(this).attr("i") == i and +d3.select(this).attr("j") == find_j)
              find_i = i
              if i != 1 then find_i = i - 1
              pred = table.selectAll("td").filter(() -> +d3.select(this).attr("i") == find_i and +d3.select(this).attr("j") == j)
              pred_next = table.selectAll("td").filter(() -> +d3.select(this).attr("i") == find_i and +d3.select(this).attr("j") == find_j)

              perc = Math.round(100  * 100 * val / +next.attr("value")) / 100
              perc_pred = Math.round(100  * 100 * +pred.attr("value") / +pred_next.attr("value")) / 100

              val_pred = +pred.attr("value")
              if mode[0] and mode[1]
                elem.text(val + " (" + perc + "%)")
              else
                if mode[0]
                  elem.text(val)
                if mode[1]
                  if j % 2
                    elem.text("---> " + perc + "%")
                  else
                    elem.text(perc + "%")

              elem.style("background-color", "white")
              if mode[2] and mode[1]
                if perc - perc_pred > 0.01
                  elem.style("background-color", "rgba(0, 255, 0, 0.05)")
                if perc - perc_pred < -0.01
                  elem.style("background-color", "rgba(255, 0, 0, 0.05)")
              else if mode[2] and mode[0]
                if val - val_pred > val_pred / 2
                  elem.style("background-color", "rgba(0, 255, 0, 0.05)")
            )
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
          .text(data[i].name)
          .attr("active", 1)
          .attr("number", i)
          .attr("class", "button")
          .style("background", COLORS[i])
          .style("float", "left")

  return legend

add_legend_events = (legend, svg, container, data, construct, margin, width, height, x_label, y_label) ->
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

          add_axes(svg, temp, margin, width, height, x_label, y_label)
          construct(svg, container, temp, margin, width, height)
    )


add_axes = (svg, data, margin, width, height, x_label, y_label) ->
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

  xAxisFun = d3.axisBottom(xScale).tickValues(dates).tickFormat(d3.timeFormat("%m.%y")).tickSize(7)
  xAxis = axes.append("g")
    .attr("id", "x_axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxisFun)

  xAxis.selectAll("text")
      .attr("text-anchor", "end")
      .attr("dx", "-.6em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-55)")
      .style("font-family", "Arial")
      .style("font-size", "14px")
      .style("font-weight", "500")

  yAxisFun = d3.axisLeft(yScale).tickSize(-width + margin.left + margin.right).tickPadding(8)
  yAxis = axes.append("g")
          .attr("id", "y_axis")
          .attr("transform", "translate(0,0)")
          .call(yAxisFun)

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

  axes.append("text")
      .text(x_label)
      .attr("transform", "translate(" + ((width - margin.left - margin.right) / 2 + margin.left) + "," + (height) + ")")
      .style("text-anchor", "middle")
      .style("font-family", "Arial")
      .style("font-size", "16px")
      .style("font-weight", "500")
      .transition()
      .duration(1000)
      .ease(d3.easeLinear)
      .attr("transform", "translate(" + ((width - margin.left - margin.right) / 2 + margin.left) + "," + (height - margin.bottom / 4) + ")")

  axes.append("text")
      .text(y_label)
      .attr("transform", "translate(0," + ((height - margin.top - margin.bottom) / 2 + margin.top) + ") rotate(-90)")
      .style("text-anchor", "middle")
      .style("font-family", "Arial")
      .style("font-size", "16px")
      .style("font-weight", "500")
      .transition()
      .duration(1000)
      .ease(d3.easeLinear)
      .attr("transform", "translate(" + (margin.left / 4) + "," + ((height - margin.top - margin.bottom) / 2 + margin.top) + ") rotate(-90)")
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
                    .style("position", "fixed")
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
