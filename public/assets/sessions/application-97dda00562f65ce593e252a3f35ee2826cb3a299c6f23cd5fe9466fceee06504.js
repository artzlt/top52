$(document).ready(function(){
  $("input#check-all-box").on("click", function(e){
    var boxes = $("input#selected_project_ids_");
    var original_box = this;
    boxes.each(function(i, e){
      e.checked = original_box.checked;
    });
  });
});
(function() {
  $(function() {
    $("div[data-max-values]").on("change :checkbox", function() {
      var condition, max;
      max = Number($(this).data("max-values"));
      if (max <= 0) {
        return;
      }
      condition = $(':checked', this).length >= max;
      return $(":not(:checked)", this).prop("disabled", condition);
    });
    $("div[data-max-values]").each(function(i, e) {
      return $(":checkbox:first", e).trigger("change");
    });
    $("table.summable").each(function(i, table) {
      var row;
      table = $(table);
      row = $("tr:last", table).clone();
      row.find("th").html("Всего");
      table.recalc = function() {
        return row.find("td").each(function(j, td) {
          var val;
          td = $(td);
          val = 0;
          $("tr", table).each(function(k, tr) {
            var v;
            v = Number($("td:eq(" + j + ")", $(tr)).find("input").val());
            if (!_(v).isNaN()) {
              return val += v;
            }
          });
          return td.html(val);
        });
      };
      table.on("blur input", (function(_this) {
        return function() {
          return table.recalc();
        };
      })(this));
      table.recalc();
      return table.append(row);
    });
    return $(".submit-survey").on("click", function() {
      var $button, $form;
      $button = $(this);
      $form = $button.parents("form:first");
      $form.prop("action", $button.data("action"));
      return true;
    });
  });

}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

;
