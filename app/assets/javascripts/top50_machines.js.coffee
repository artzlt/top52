@test_fun = (text) ->
  #dsdfgdsfsa
  console.log("AAAAAAAAAAAAAAAAAAAAAAA" + text)

# drawing performance chart
@draw_performance = (data, src_id, title, x_label, y_label, COLORS = d3.schemeSet1, is_performance = false) ->
  for i in [0..data.length - 1]
    data[i].color = i
    for j in [0..data[i].data.length - 1]
      s = data[i].data[j][0].split(".")
      data[i].data[j][0] = new Date(+s[2], +s[1] - 1, +s[0])
      data[i].data[j][1] = +data[i].data[j][1]

  console.log(data)

  # onload function
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

    legend = add_legend(container, data, COLORS)

    buttons = container.append("g").attr("id", "buttons")

    # changing view buttons
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

    if (!is_performance)
      bar_button = buttons.append("div")
                .text("bar")
                .attr("class", "button")
                .style("background", "gray")
                .style("float", "right")
                .attr("name", "type")
                .property("checked", "false")

    # table control processing
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

    # adding svg elements
    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    add_legend_events(legend, svg, container, data, add_line_chart, margin, width, height, x_label, y_label, false, false, COLORS)
    add_axes(svg, container, data, margin, width, height, x_label, y_label)
    add_line_chart(svg, container, data, margin, width, height, COLORS)

    # defining buttons actions
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

        add_legend_events(legend, svg, container, data, add_line_chart, margin, width, height, x_label, y_label, false, false, COLORS)
        add_axes(svg, container, data_to_draw, margin, width, height, x_label, y_label)
        add_line_chart(svg, container, data_to_draw, margin, width, height, COLORS)       
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

        add_legend_events(legend, svg, container, temp, add_line_chart, margin, width, height, x_label, "Логарифм", false, false, COLORS)
        add_axes(svg, container, data_to_draw, margin, width, height, x_label, "Логарифм")
        add_line_chart(svg, container, data_to_draw, margin, width, height, COLORS)       
    )

    if (!is_performance)
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

          add_legend_events(legend, svg, container, temp, add_bar_chart, margin, width, height, x_label, y_label, true, false, COLORS)
          add_axes(svg, container, bar_data, margin, width, height, x_label, y_label)
          add_bar_chart(svg, container, data_to_draw, margin, width, height, COLORS)
      )

    # table control buttons actions defining
    table_control.selectAll("div").on("click", (d, i) ->
      d3.select(this).property("checked", !d3.select(this).property("checked"))
      mode[i] = d3.select(this).property("checked")
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
                    elem.text(perc + "%")
                  else
                    elem.text(perc + "% --->")

              elem.style("background-color", "white")
              if mode[2] and mode[1]
                if perc > perc_pred
                  elem.style("background-color", "rgba(0, 255, 0, 0.05)")
                if perc < perc_pred 
                  elem.style("background-color", "rgba(255, 0, 0, 0.05)")
              else if mode[2] and mode[0]
                if val > val_pred
                  elem.style("background-color", "rgba(0, 255, 0, 0.05)")
            )
    )

  # adding new onload function
  oldonload = window.onload;
  if typeof(window.onload) != "function"
    window.onload = func
  else
    window.onload = () ->
      if (oldonload)
        oldonload()
      func()
  return 0


# drawing area chart
@draw_area = (data, data_per, src_id, title, x_label, y_label, COLORS = d3.schemeSet1) ->
  for i in [0..data.length - 1]
    data[i].color = i
    data_per[i].color = i
    for j in [0..data[i].data.length - 1]
      s = data[i].data[j][0].split(".")
      data[i].data[j][0] = new Date(+s[2], +s[1] - 1, +s[0])
      data[i].data[j][1] = +data[i].data[j][1]
      s = data_per[i].data[j][0].split(".")
      data_per[i].data[j][0] = new Date(+s[2], +s[1] - 1, +s[0])
      data_per[i].data[j][1] = +data_per[i].data[j][1]

  console.log(data)
  console.log(data_per)

  # defining onload function
  func = () ->
    width = document.getElementById(src_id).offsetWidth
    height = 550

    margin =
      top : 10
      bottom : 80
      right : 10
      left : 80

    container = d3.selectAll("div").filter(() -> d3.select(this).attr("id") == src_id)

    # adding title and legend
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

    legend = add_legend(container, data, COLORS)

    # adding view control buttons
    buttons = container.append("g").attr("id", "buttons")
    log_button = buttons.append("div")
              .text("log")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .attr("title", "логарифмическая шкала производительности процессоров")
              .property("checked", "false")
    per_part_bar_button = buttons.append("div")
              .text("3rd bar")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .attr("title", "производительность процессоров")
              .property("checked", "false")
    per_bar_button = buttons.append("div")
              .text("2nd bar")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .attr("title", "доля производительности")
              .property("checked", "false")
    bar_button = buttons.append("div")
              .text("1st bar")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .attr("title", "доля по количеству систем")
              .property("checked", "false")
    pie_button = buttons.append("div")
              .text("pie")
              .attr("class", "button")
              .style("background", "#6699CC")
              .style("float", "right")
              .attr("name", "type")
              .property("checked", "true")

    # adding svg elements
    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    # function for multiple pies via 1 constructor
    add_pies = (svg, container, data, margin, width, height, colors = d3.schemeSet1, measure = y_label) ->
      temp_per = []
      data.forEach((elem) ->
        data_per.forEach((elem_per) ->
          if elem.name == elem_per.name
            temp_per.push(elem_per)
        )
      )
      # making pies
      zoom_func1 = add_pie_chart(svg, container, data, {"top": 10, "bottom": 80, "right": 10 + width / 2, "left": 80}, width, height, COLORS, measure)
      zoom_func2 = add_pie_chart(svg, container, temp_per, {"top": 10, "bottom": 80, "right": 10, "left": 80 + width / 2}, width, height, COLORS, "Производительность, ПФлоп/с")
      # making total zoom function
      zoom_func = () ->
        zoom_func1()
        zoom_func2() 

      zoom = d3.zoom()
            .scaleExtent([1, 1.5])
            .on("zoom", zoom_func)

      if navigator.userAgent.search(/firefox/i) != -1
        zoom.wheelDelta(() ->
              return -d3.event.deltaY * (d3.event.deltaMode ? 120 : 1) / 500
            )

      svg.call(zoom) 

    add_legend_events(legend, svg, container, data, add_pies, margin, width, height, x_label, y_label, false, true, COLORS)
    add_pies(svg, container, data, {"top": 10, "bottom": 80, "right": 10 + width / 2, "left": 80}, width, height)

    # table control processing
    table_control = d3.selectAll("g").filter(() -> d3.select(this).attr("id") == "table_control_" + src_id)
    mode = [true, false, false]
    table = d3.selectAll("table").filter(() -> d3.select(this).attr("id") == "table_" + src_id)
    table_control.selectAll("div").filter(() -> d3.select(this).attr("id") == "0")
                .property("checked", true)
                .each(() -> console.log(d3.select(this).property("checked")))
    table_control.selectAll("div").filter(() -> d3.select(this).attr("id") != "0")
                .property("checked", false)
                .each(() -> console.log(d3.select(this).property("checked")))

    # function for change view actions
    bar_button_action = () ->
      buttons.selectAll("div[name='type']").each(() ->
        if d3.select(this).property("checked")
          d3.select(this)
            .transition()
            .ease(d3.easeLinear)
            .duration(500)
            .style("background", "gray")
      )
      if d3.select(this).text() == "1st bar"
        required_data = data
      else
        required_data = data_per
      if d3.select(this).property("checked")
        temp = []
        for x, i in required_data
          temp.push({})
          temp[i].name = x.name
          temp[i].color = x.color
          temp[i].data = []
          for y, j in x.data
            sum = 100
            if d3.select(this).text() == "2nd bar" || d3.select(this).text() == "1st bar"
              sum = 0
              required_data.forEach((elem) -> sum += elem.data[j][1])
            temp[i].data.push([y[0], y[1] * 100 / sum])

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

        add_legend_events(legend, svg, container, temp, add_bar_chart, margin, width, height, x_label, y_label, true, false, COLORS)
        if d3.select(this).text() == "3rd bar"
          add_axes(svg, container, bar_data, margin, width, height, x_label, "Производительность, ПФлоп/с")
        else if d3.select(this).text() == "2nd bar"
          add_axes(svg, container, bar_data, margin, width, height, x_label, "Доля производительности")
        else
          add_axes(svg, container, bar_data, margin, width, height, x_label, y_label)
        add_bar_chart(svg, container, data_to_draw, margin, width, height, COLORS)

    # view control buttons actions defining
    bar_button.on("click", bar_button_action)

    per_bar_button.on("click", bar_button_action)

    per_part_bar_button.on("click", bar_button_action)

    pie_button.on("click", () ->
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

        add_legend_events(legend, svg, container, temp, add_pies, margin, width, height, x_label, y_label, false, true, COLORS)
        add_pies(svg, container, data_to_draw, {"top": 10, "bottom": 80, "right": 10 + width / 2, "left": 80}, width, height)
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
        for x, i in data_per
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

        add_legend_events(legend, svg, container, temp, add_line_chart, margin, width, height, x_label, "Логарифм", false, false, COLORS)
        add_axes(svg, container, data_to_draw, margin, width, height, x_label, "Логарифм")
        add_line_chart(svg, container, data_to_draw, margin, width, height, COLORS)
    )

    table_control.selectAll("div").on("click", (d, i) ->
      console.log("div click")
      d3.select(this).property("checked", !d3.select(this).property("checked"))
      mode[i] = d3.select(this).property("checked")
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
      console.log("control click")
      table.selectAll("td")
            .filter(() -> d3.select(this).attr("class") != "fit")
            .each(() ->
              elem = d3.select(this)
              i = +elem.attr("i")
              j = +elem.attr("j")

              sum_cnt = 0
              sum_per = 0
              data.forEach((elem) -> sum_cnt += elem.data[i - 1][1])
              data_per.forEach((elem) -> sum_per += elem.data[i - 1][1])
              str_cnt = data[j].data[i - 1][1]
              str_per = data_per[j].data[i - 1][1]
              if mode[2]
                str_cnt = Math.floor(str_cnt * 10000 / sum_cnt) / 100 + "%"
                str_per = Math.floor(str_per * 10000 / sum_per) / 100 + "%"
              if mode[0] && mode[1]
                elem.text(str_cnt + " / " + str_per)
              else if mode[1]
                elem.text(str_per)
              else if mode[0]
                elem.text(str_cnt)
              else
                elem.text("-")
            )
    )  

  # adding new onload function
  oldonload = window.onload;
  if typeof(window.onload) != "function"
    window.onload = func
  else
    window.onload = () ->
      if (oldonload)
        oldonload()
      func()
  return 0

# drawing area chart
@draw_type = (data, src_id, title, x_label, y_label, COLORS = d3.schemeSet1) ->
  for i in [0..data.length - 1]
    data[i].color = i
    for j in [0..data[i].data.length - 1]
      s = data[i].data[j][0].split(".")
      data[i].data[j][0] = new Date(+s[2], +s[1] - 1, +s[0])
      data[i].data[j][1] = +data[i].data[j][1]

  console.log(data)

  # defining onload function
  func = () ->
    width = document.getElementById(src_id).offsetWidth
    height = 550

    margin =
      top : 10
      bottom : 80
      right : 10
      left : 80

    container = d3.selectAll("div").filter(() -> d3.select(this).attr("id") == src_id)

    # adding title and legend
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

    legend = add_legend(container, data, COLORS)

    # adding svg elements
    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    # preparing data for axes
    bar_data = [{"data" : []}]
    for i in [0..data[0].data.length - 1]
      bar_data[0].data.push([data[0].data[i][0], 0])
      for j in [0..data.length - 1]
        bar_data[0].data[i][1] += data[j].data[i][1]

    add_legend_events(legend, svg, container, data, add_bar_chart, margin, width, height, x_label, y_label, true, false, COLORS)
    add_axes(svg, container, bar_data, margin, width, height, x_label, y_label)
    add_bar_chart(svg, container, data, margin, width, height, COLORS)

  # adding new onload function
  oldonload = window.onload;
  if typeof(window.onload) != "function"
    window.onload = func
  else
    window.onload = () ->
      if (oldonload)
        oldonload()
      func()
  return 0

# drawing vendors chart
@draw_vendors = (data, src_id, title, x_label, y_label, COLORS = d3.schemeSet1) ->
  for i in [0..data.length - 1]
    data[i].color = i
    for j in [0..data[i].data.length - 1]
      s = data[i].data[j][0].split(".")
      data[i].data[j][0] = new Date(+s[2], +s[1] - 1, +s[0])
      data[i].data[j][1] = +data[i].data[j][1]

  console.log(data)

  # defining onload function
  func = () ->
    width = document.getElementById(src_id).offsetWidth
    height = 550

    margin =
      top : 10
      bottom : 80
      right : 10
      left : 80

    container = d3.selectAll("div").filter(() -> d3.select(this).attr("id") == src_id)

    # adding title and legend
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

    legend = add_legend(container, data, COLORS)

    # adding view control buttons
    buttons = container.append("g").attr("id", "buttons")
    bar_button = buttons.append("div")
              .text("bar")
              .attr("class", "button")
              .style("background", "gray")
              .style("float", "right")
              .attr("name", "type")
              .attr("title", "доля по количеству систем")
              .property("checked", "false")
    pie_button = buttons.append("div")
              .text("pie")
              .attr("class", "button")
              .style("background", "#6699CC")
              .style("float", "right")
              .attr("name", "type")
              .property("checked", "true")

    # adding svg elements
    svg = container.append("svg").attr("style", "width:100%; height:" + height + "px").attr("id", "svg_" + src_id)

    add_legend_events(legend, svg, container, data, add_pie_chart, margin, width, height, x_label, y_label, false, true, COLORS)
    zoom_func = add_pie_chart(svg, container, data, margin, width, height, COLORS, "Количество систем")
    zoom = d3.zoom()
          .scaleExtent([1, 32])
          .on("zoom", zoom_func)

    if navigator.userAgent.search(/firefox/i) != -1
        zoom.wheelDelta(() ->
              return -d3.event.deltaY * (d3.event.deltaMode ? 120 : 1) / 500
            )

    svg.call(zoom) 

    # view control buttons actions defining
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

        add_legend_events(legend, svg, container, temp, add_bar_chart, margin, width, height, x_label, y_label, true, false, COLORS)
        add_axes(svg, container, bar_data, margin, width, height, x_label, y_label)
        add_bar_chart(svg, container, data_to_draw, margin, width, height, COLORS)
    )

    pie_button.on("click", () ->
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

        add_legend_events(legend, svg, container, temp, add_pie_chart, margin, width, height, x_label, y_label, false, true, COLORS)
        zoom_func = add_pie_chart(svg, container, data_to_draw, margin, width, height, COLORS, "Количество систем")
        zoom = d3.zoom()
              .scaleExtent([1, 1.5])
              .on("zoom", zoom_func)

        svg.call(zoom) 
    )


  # adding new onload function
  oldonload = window.onload;
  if typeof(window.onload) != "function"
    window.onload = func
  else
    window.onload = () ->
      if (oldonload)
        oldonload()
      func()
  return 0

#--------------------
# ADDITIONAL FUCTIONS
#--------------------


# adding chart legend
add_legend = (container, data, colors = d3.schemeSet1) ->
  legend = container.append("g").attr("id", "legend")

  for set, i in data
    legend.append("div")
          .text(data[i].name)
          .attr("active", 1)
          .attr("number", i)
          .attr("class", "button")
          .style("background", colors[i])
          .style("float", "left")

  return legend

# adding chart legend actions
add_legend_events = (legend, svg, container, data, construct, margin, width, height, x_label, y_label, accumulation = false, pie = false, colors = d3.schemeSet1) ->
  legend.selectAll("div")
    .on("click", () ->
          d3.select(this).attr("active", (+d3.select(this).attr("active") + 1) % 2)
            .transition()
            .duration(500)
            .style("background", () -> 
              if +d3.select(this).attr("active")
                return colors[+d3.select(this).attr("number")]
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

          axes_data = temp
          if accumulation
            axes_data = [{"data" : []}]
            for i in [0..temp[0].data.length - 1]
              axes_data[0].data.push([data[0].data[i][0], 0])
              for j in [0..temp.length - 1]
                axes_data[0].data[i][1] += temp[j].data[i][1]

          if !pie
            add_axes(svg, container, axes_data, margin, width, height, x_label, y_label)
            construct(svg, container, temp, margin, width, height, colors)
          else
            zoom_func = construct(svg, container, temp, margin, width, height, colors)
            zoom = d3.zoom()
                    .scaleExtent([1, 1.5])
                    .on("zoom", zoom_func)

            svg.call(zoom)
    )


# adding chart axes
add_axes =  (svg, container, data, margin, width, height, x_label, y_label) ->
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

  # adding scale and movement action
  zoom_func = () ->
    newXScale = d3.event.transform.rescaleX(xScale)
    newYScale = d3.event.transform.rescaleY(yScale)

    x_dates = []
    y_domain = [yScale.domain()[1], yScale.domain()[0]]
    bar_max = 0
    data[0].data.forEach((d, i) ->
      if d[0] > newXScale.domain()[0] && d[0] < newXScale.domain()[1]
        x_dates.push(d[0])
        sum = 0
        for set in data
          if set.data[i][1] < y_domain[0]
            y_domain[0] = set.data[i][1]
          if set.data[i][1] > y_domain[1]
            y_domain[1] = set.data[i][1]
          sum += set.data[i][1]
        if sum > bar_max
          bar_max = sum
    )

    newYScale.domain(y_domain)
    newBarYScale = d3.scaleLinear()
                    .domain([0, bar_max])
                    .range([height - margin.bottom, margin.top])

    # update axes
    xAxis.call(xAxisFun.tickValues(x_dates).scale(newXScale))
    yAxis.call(yAxisFun.scale(newYScale))

    xAxis.selectAll("text")
        .attr("text-anchor", "end")
        .attr("dx", "-.6em")
        .attr("dy", ".15em")
        .attr("transform", "rotate(-55)")
        .style("font-family", "Arial")
        .style("font-size", "14px")
        .style("font-weight", "500")
    yAxis.selectAll("text")
        .style("font-family", "Arial")
        .style("font-size", "14px")
        .style("font-weight", "500")
    yAxis.selectAll("line")
        .attr("dashoffset", 10)
        .style("stroke-dasharray", "7 5")
        .style("opacity", "0.2")

    chart = svg.selectAll("g").filter(() -> d3.select(this).attr("id") == "chart")
    chart.selectAll("circle")
          .transition()
          .duration(100)
          .ease(d3.easeLinear)
          .attr("cx", (d) -> newXScale(d[0]))
          .attr("cy", (d) -> newYScale(d[1]))
          .each((d) ->
            if newXScale(d[0]) < margin.left || newXScale(d[0]) > width - margin.right || newYScale(d[1]) < margin.top || newYScale(d[1]) > height - margin.bottom
              d3.select(this).style("opacity", 0)
            else
              d3.select(this).style("opacity", 1)
          )

    line = d3.line()
            .x((d) ->
              if newXScale(d[0]) < margin.left
                return margin.left
              if newXScale(d[0]) > width - margin.right
                return width - margin.right
              return newXScale(d[0])
            )
            .y((d) ->
              if newYScale(d[1]) < margin.top
                return margin.top
              if newYScale(d[1]) > height - margin.bottom
                return height - margin.bottom
              return newYScale(d[1])
            )
            .curve(d3.curveMonotoneX)
    
    # scaling paths
    chart.selectAll("path")
          .style("stroke-dasharray", 0)
          .transition()
          .duration(100)
          .ease(d3.easeLinear)
          .attr("d", (d, i) ->
            path_data = []
            data[i].data.forEach((el, j) ->
              if el[0] >= newXScale.domain()[0] && el[0] <= newXScale.domain()[1] && el[1] >= newYScale.domain()[0] && el[1] <= newYScale.domain()[1]
                path_data.push(el)
              else if j != data[i].data.length - 1 && data[i].data[j + 1][0] >= newXScale.domain()[0] && data[i].data[j + 1][0] <= newXScale.domain()[1] && data[i].data[j + 1][1] >= newYScale.domain()[0] && data[i].data[j + 1][1] <= newYScale.domain()[1]
                path_data.push(el)
              else if j && data[i].data[j - 1][0] >= newXScale.domain()[0] && data[i].data[j - 1][0] <= newXScale.domain()[1] && data[i].data[j - 1][1] >= newYScale.domain()[0] && data[i].data[j - 1][1] <= newYScale.domain()[1]
                path_data.push(el)
            )
            line(path_data)
          )

    # scaling bar chart
    rect_width = width / (x_dates.length * 2)
    chart.selectAll("rect")
          .transition()
          .duration(100)
          .ease(d3.easeLinear)
          .attr("width", rect_width)
          .attr("height", (d) -> newBarYScale(d[0]) - newBarYScale(d[1]))
          .attr("x", (d) -> newXScale(d.data.date) - rect_width / 2)
          .attr("y", (d) -> newBarYScale(d[1]))
          .each((d) ->
            if newXScale(d.data.date) - rect_width / 2 < margin.left || newXScale(d.data.date) + rect_width / 2 > width + margin.right
              d3.select(this).style("opacity", 0)
            else
              d3.select(this).style("opacity", 1)
          )
    add_bar_chart_event(svg, container, newXScale, newBarYScale)

  zoom = d3.zoom()
          .scaleExtent([1, 100])
          .translateExtent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]])
          .extent([[margin.left, margin.top], [width - margin.right, height - margin.bottom]])
          .on("zoom", zoom_func)

  if navigator.userAgent.search(/firefox/i) != -1
        zoom.wheelDelta(() ->
              return -d3.event.deltaY * (d3.event.deltaMode ? 120 : 1) / 500
            )

  svg.call(zoom)
  return axes


# adding line chart
add_line_chart = (svg, container, data, margin, width, height, colors = d3.schemeSet1) ->
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
      .style("stroke", colors[set.color])
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
      .style("fill", colors[set.color])
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

  # adding chart elements actions
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
            .style("stroke", () -> colors[d3.select(this).attr("color")])
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
              .style("background", colors[d3.select(this).attr("color")])
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
            .style("fill", () -> colors[d3.select(this).attr("color")])
            .style("stroke-width", 0)

        tooltip.transition()
            .duration(300)
            .ease(d3.easeElastic)
            .style("opacity", 0)
            .style("top", "0px")
    )
  return chart


# adding bar chart actions by axes scales
add_bar_chart_event = (svg, container, xScale, yScale) ->
  tooltip = container.selectAll("div")
                    .filter(() -> d3.select(this).attr("id") == "tooltip_" + container.attr("id"))

  svg.selectAll("rect")
    .on("mouseover", () ->
        elem = d3.select(this)

        elem.transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .style("stroke-width", 0.05)

        svg.selectAll("rect")
            .filter(() -> d3.select(this).attr("x") != elem.attr("x") || d3.select(this).attr("y") != elem.attr("y"))
            .transition()
            .duration(1500)
            .ease(d3.easeElastic)
            .style("stroke-width", 8)

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
    )
    .on("mouseout", () ->
        xcord = d3.select(this).attr("cx");
        svg.selectAll("rect")
            .transition()
            .duration(2000)
            .ease(d3.easeElastic)
            .style("stroke-width", 2)

        tooltip.transition()
            .duration(300)
            .ease(d3.easeElastic)
            .style("opacity", 0)
            .style("top", "0px")
    )

# drawing bar chart
add_bar_chart = (svg, container, data, margin, width, height, colors = d3.schemeSet1) ->
  months = 1000 * 60 * 60 * 24 * 30 * 4
  right_date = new Date(data[0].data[data[0].data.length - 1][0])
  xScale = d3.scaleTime()
            .domain([data[0].data[0][0] - months, right_date.setTime(right_date.getTime() + months)])
            .range([margin.left, width - margin.right])

  stack = d3.stack()
            .keys([0..data.length - 1])

  # processing data for bar chart
  bar_data = []
  for i in [0..data[0].data.length - 1]
    bar_data.push({"date" : data[0].data[i][0]})
    for j in [0..data.length - 1]
      bar_data[i][j] = data[j].data[i][1]
  
  bar_max = 0
  data[0].data.forEach((d, i) ->
    sum = 0
    for set in data
      sum += set.data[i][1]
    if sum > bar_max
      bar_max = sum
  )

  bar_data = stack(bar_data)
  console.log(bar_data)

  yScale = d3.scaleLinear()
              .domain([0, bar_max])
              .range([height - margin.bottom, margin.top])

  loc_colors = data.map((d) -> d.color)

  chart = svg.append("g").attr("id", "chart")

  rect_width = width / (data[0].data.length * 2)

  chart.selectAll("g")
        .data(bar_data)
        .enter()
        .append("g")
        .style("fill", (d, i) -> colors[loc_colors[i]])
        .selectAll("rect")
        .data((d) -> d)
        .enter()
        .append("rect")
        .attr("value", (d) -> Math.round((d[1] - d[0]) * 100) / 100)
        .attr("x", (d) -> xScale(d.data.date) - rect_width / 2)
        .attr("width", rect_width)
        .attr("rx", 4)
        .attr("ry", 4)
        .attr("y", height - margin.bottom)
        .style("stroke", "white")
        .style("stroke-width", 2)
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
                    .style("border-color", "white")

  add_bar_chart_event(svg, container, xScale, yScale)
  return chart


# drawing pie chart
# WARNING!!! returning zoom function
# not setting zoom automaticly
add_pie_chart = (svg, container, data, margin, width, height, colors = d3.schemeSet1, measure = "Количество систем") ->
  chart = svg.append("g").attr("id", "chart")

  pie = d3.pie().value((d) -> d.data[d.data.length - 1][1])
  loc_colors = data.map((d) -> d.color)
  outer_radius = Math.min(width - margin.left - margin.right, height - margin.top - margin.bottom) * 0.4
  arc = d3.arc().innerRadius(0.01).outerRadius(outer_radius)
  big_arc = d3.arc().innerRadius(outer_radius / 3).outerRadius(outer_radius * 4 / 3).padAngle(0.04)
  label_arc = d3.arc().innerRadius(0.6 * outer_radius).outerRadius(0.6 * outer_radius)
  tip = d3.arc().innerRadius(outer_radius).outerRadius(outer_radius * 4 / 3).padAngle(0.04)
  center =
    left : (width - margin.left - margin.right) / 2 + margin.left
    top : (height - margin.top - margin.bottom) / 2 + margin.top

  total_value = 0
  arcs = chart.selectAll("g")
              .data(pie(data))
              .enter()
              .append("g")
              .attr("id", "arc")
              .attr("value", (d) -> d.value)
              .attr("redaction", data[0].data.length - 1)
              .each((d) -> total_value += d.value) 
              
  arcs.append("path")
      .attr("value", (d) -> d.value)
      .attr("redaction", data[0].data.length - 1)
      .attr("fill", (d, i) -> colors[loc_colors[i]])
      .attr('transform', "translate(-" + outer_radius + ",-" + outer_radius + ")")
      .transition()
      .duration(1000)
      .ease(d3.easeBackOut)
      .attr('transform', "translate(" + center.left + "," + center.top + ")")
      .attr("d", arc)
      .attrTween("d", (d) ->
          i = d3.interpolate(0, d.endAngle)
          j = d3.interpolate(0, d.startAngle)
          pad = d3.interpolate(d.padAngle, 0)
          return (t) ->
              d.endAngle = i(t)
              d.startAngle = j(t)
              d.padAngle = pad(t)
              return arc(d)
      )

  arcs.append("text")
      .attr("id", "label")
      .attr('transform', "translate(-" + outer_radius + ",-" + outer_radius + ")")
      .transition()
      .duration(1000)
      .ease(d3.easeBackOut)
      .attr("transform", (d) ->
            trans = [label_arc.centroid(d)[0] + center.left, label_arc.centroid(d)[1] + center.top]
            "translate(" + trans + ")"
      )
      .style("font-family", "Arial")
      .style("font-size", "14px")
      .style("font-weight", "600")
      .style("float", "right")
      .style("fill", "white")
      .style("opacity", (d) -> +(Math.round(+d3.select(this.parentNode).attr("value") * 100 / total_value) >= 5))
      .text((d) -> Math.round(+d3.select(this.parentNode).attr("value") * 100 / total_value) + "%")

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
                    .style("border-color", "white")

  init_date = data[0].data[data[0].data.length - 1][0]
  init_date_str = data[0].data.length + "-я редакция (" + (init_date.getMonth() + 1) + "." + init_date.getFullYear() + ")"
  chart.append("text")
        .attr("id", "redaction")
        .attr("transform", "translate(" + center.left + ", " + (height + margin.bottom) + ")")
        .style("background", "white")
        .transition()
        .duration(300)
        .attr("transform", "translate(" + center.left + ", " + (height - margin.bottom / 2) + ")")
        .style("text-anchor", "middle")
        .style("font-family", "Arial")
        .style("font-size", "16px")
        .style("font-weight", "500")
        .text(init_date_str)

  chart.append("text")
        .attr("transform", "translate(" + center.left + ", " + (height + margin.bottom) + ")")
        .style("background", "white")
        .transition()
        .duration(300)
        .attr("transform", "translate(" + center.left + ", " + (height - margin.bottom * 1.2) + ")")
        .style("text-anchor", "middle")
        .style("font-family", "Arial")
        .style("font-size", "16px")
        .style("font-weight", "500")
        .text(measure)

  # adding pie chart actions
  chart.selectAll("g")
    .filter((d) -> d3.select(this).attr("id") == "arc")
    .selectAll("path")
    .on("mouseover", () ->
        elem = d3.select(this)
        rel_pos = []

        elem.transition()
            .duration(300)
            .attr("d", big_arc)
            .each((d) -> rel_pos = tip.centroid(d))

        d3.select(this.parentNode).select("text").style("opacity", 0.0)

        left = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().left - document.getElementById("tooltip_" + container.attr("id")).offsetWidth + 5
        top = document.getElementById("svg_" + container.attr("id")).getBoundingClientRect().top - document.getElementById("tooltip_" + container.attr("id")).offsetHeight + 5
        tooltip.transition()
              .duration(300)
              .ease(d3.easeElastic)
              .style("opacity", 1)
              .style("background", elem.style("fill"))
              .text(elem.attr("value"))
              .style("left", (rel_pos[0] + left + center.left) + "px")
              .style("top", (rel_pos[1] + top + center.top) + "px")
    )
    .on("mouseout", () ->
        elem = d3.select(this)

        elem.transition()
            .duration(300)
            .attr("d", arc)

        d3.select(this.parentNode).select("text").style("opacity", (d) -> +(Math.round(+d3.select(this.parentNode).attr("value") * 100 / total_value) >= 5))  

        tooltip.transition()
            .duration(300)
            .ease(d3.easeElastic)
            .style("opacity", 0)
            .style("top", "0px")
    )
  
  # adiing pie chart zooming
  zoom_func = () ->
    scale_step = 0.5 / (data[0].data.length - 1)
    cur_number = Math.floor((d3.event.transform.k - 1) / scale_step)
    if cur_number != +chart.select("path").attr("redaction")
      pie.value((d) -> d.data[cur_number][1])

      total_value = 0
      chart.selectAll("g")
          .filter((d) -> d3.select(this).attr("id") == "arc")
          .data(pie(data))
          .attr("value", (d) -> d.value)
          .attr("redaction", cur_number)
          .each((d) -> total_value += d.value)

      chart.selectAll("path")
          .data(pie(data))
          .attr("value", (d) -> d.value)
          .attr("redaction", cur_number)
          .transition()
          .duration(300)
          .attr("d", arc)

      chart.selectAll("text")
          .filter((d) -> d3.select(this).attr("id") == "label")
          .data(pie(data))
          .attr("transform", (d) ->
                trans = [label_arc.centroid(d)[0] + center.left, label_arc.centroid(d)[1] + center.top]
                "translate(" + trans + ")"
          )
          .style("opacity", (d) -> +(Math.round(+d3.select(this.parentNode).attr("value") * 100 / total_value) >= 5))
          .text((d) -> Math.round(+d3.select(this.parentNode).attr("value") * 100 / total_value) + "%")

      date = data[0].data[cur_number][0]
      date_str = (cur_number + 1) + "-я редакция (" + (date.getMonth() + 1) + "." + date.getFullYear() + ")"
      chart.selectAll("text")
            .filter((d) -> d3.select(this).attr("id") == "redaction")
            .transition()
            .duration(300)
            .text(date_str)

  return zoom_func

$ ->
  $("#add-form-link").click ->	
    onstr = "Показать поля ввода"
    offstr = "Скрыть поля ввода"
    $(this).text(if $(this).text() == onstr then offstr else onstr)
    $("#just-text").toggle()
    $("#form-new_machine").toggle()

  $("#top50_machine_org_id").change ->
    org_id = $(this).val()
    url = "/organizations/#{org_id}/suborgs"
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
