(function($) {
  window.NestedFormEvents = function() {
    this.addFields = $.proxy(this.addFields, this);
    this.removeFields = $.proxy(this.removeFields, this);
  };

  NestedFormEvents.prototype = {
    addFields: function(e) {
      // Setup
      var link      = e.currentTarget;
      var assoc     = $(link).data('association');                // Name of child
      var blueprint = $('#' + $(link).data('blueprint-id'));
      var content   = blueprint.data('blueprint');                // Fields template

      // Make the context correct by replacing <parents> with the generated ID
      // of each of the parent objects
      var context = ($(link).closest('.fields').closestChild('input, textarea, select').eq(0).attr('name') || '').replace(new RegExp('\[[a-z_]+\]$'), '');

      // context will be something like this for a brand new form:
      // project[tasks_attributes][1255929127459][assignments_attributes][1255929128105]
      // or for an edit form:
      // project[tasks_attributes][0][assignments_attributes][1]
      if (context) {
        var parentNames = context.match(/[a-z_]+_attributes(?=\]\[(new_)?\d+\])/g) || [];
        var parentIds   = context.match(/[0-9]+/g) || [];

        for(var i = 0; i < parentNames.length; i++) {
          if(parentIds[i]) {
            content = content.replace(
              new RegExp('(_' + parentNames[i] + ')_.+?_', 'g'),
              '$1_' + parentIds[i] + '_');

            content = content.replace(
              new RegExp('(\\[' + parentNames[i] + '\\])\\[.+?\\]', 'g'),
              '$1[' + parentIds[i] + ']');
          }
        }
      }

      // Make a unique ID for the new child
      var regexp  = new RegExp('new_' + assoc, 'g');
      var new_id  = this.newId();
      content     = $.trim(content.replace(regexp, new_id));

      var field = this.insertFields(content, assoc, link);
      // bubble up event upto document (through form)
      field
        .trigger({ type: 'nested:fieldAdded', field: field })
        .trigger({ type: 'nested:fieldAdded:' + assoc, field: field });
      return false;
    },
    newId: function() {
      return new Date().getTime();
    },
    insertFields: function(content, assoc, link) {
      var target = $(link).data('target');
      if (target) {
        return $(content).appendTo($(target));
      } else {
        return $(content).insertBefore(link);
      }
    },
    removeFields: function(e) {
      var $link = $(e.currentTarget),
          assoc = $link.data('association'); // Name of child to be removed
      
      var hiddenField = $link.prev('input[type=hidden]');
      hiddenField.val('1');
      
      var field = $link.closest('.fields');
      field.hide();
      
      field
        .trigger({ type: 'nested:fieldRemoved', field: field })
        .trigger({ type: 'nested:fieldRemoved:' + assoc, field: field });
      return false;
    }
  };

  window.nestedFormEvents = new NestedFormEvents();
  $(document)
    .delegate('form a.add_nested_fields',    'click', nestedFormEvents.addFields)
    .delegate('form a.remove_nested_fields', 'click', nestedFormEvents.removeFields);
})(jQuery);

// http://plugins.jquery.com/project/closestChild
/*
 * Copyright 2011, Tobias Lindig
 *
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 */
(function($) {
        $.fn.closestChild = function(selector) {
                // breadth first search for the first matched node
                if (selector && selector != '') {
                        var queue = [];
                        queue.push(this);
                        while(queue.length > 0) {
                                var node = queue.shift();
                                var children = node.children();
                                for(var i = 0; i < children.length; ++i) {
                                        var child = $(children[i]);
                                        if (child.is(selector)) {
                                                return child; //well, we found one
                                        }
                                        queue.push(child);
                                }
                        }
                }
                return $();//nothing found
        };
})(jQuery);
(function() {
  $(function() {
    return $("#new_department_adder").on("click", function() {
      $("#employment_organization_department_name").attr("type", "text");
      $("#new_department_adder").hide();
      return false;
    });
  });

}).call(this);
(function() {
  $(function() {
    var reinit_select2;
    $("#new_city_adder").on("click", function() {
      $("#organization_city_title").attr("type", "text");
      $("#new_city_adder").hide();
      return false;
    });
    $('#q_country_id_eq').change(function() {
      var country_id, select, url;
      country_id = $(this).val();
      url = "/core/countries/" + country_id + "/cities";
      select = $("#q_city_id_eq");
      select.select2("val", "");
      select.data('source', url);
      return reinit_select2(select);
    });
    $('#organization_country_id').change(function() {
      var country_id, select, url;
      country_id = $(this).val();
      url = "/core/countries/" + country_id + "/cities";
      select = $("#organization_city_id");
      select.select2("val", "");
      select.data('source', url);
      return reinit_select2(select);
    });
    return reinit_select2 = function(el) {
      var options, select;
      select = $(el);
      options = select.find("option");
      if (options.size() === 1) {
        $(options[0]).select();
      }
      options = {
        placeholder: select2_localization[window.locale],
        allowClear: true
      };
      options.ajax = {
        url: select.data("source"),
        dataType: "json",
        quietMillis: 100,
        data: function(term, page) {
          return {
            q: $.trim(term),
            page: page,
            per: 10
          };
        },
        results: function(data, page) {
          var more;
          more = void 0;
          more = (page * 10) < data.total;
          return {
            results: data.records,
            more: more
          };
        }
      };
      options.dropdownCssClass = "bigdrop";
      options.initSelection = function(element, callback) {
        if (element.val().length > 0) {
          return $.getJSON(select.data("source") + "/" + element.val(), {}, function(data) {
            return callback({
              id: data.id,
              text: data.text
            });
          });
        }
      };
      return select.select2(options);
    };
  });

}).call(this);
$().ready(function(){
  $("#member_adder").bind("click", function(){
    $("tr#new_member_row").toggleClass("hidden");
    return false;
  })

  $(".project_access_toggle").each(function() {
    return $(this).on("click", function() {
      return $.ajax({
        url: $(this).attr("url"),
        type: "PUT"
      });
    });
});
})
;
(function() {
  $(function() {
    var reinit_select2;
    $("#project_organization_id").change(function() {
      var organization_id, select, url;
      organization_id = $(this).val();
      url = "/core/organizations/" + organization_id + "/departments";
      select = $("#project_organization_department_id");
      select.select2("val", "");
      select.data("source", url);
      return reinit_select2(select);
    });
    return reinit_select2 = function(el) {
      var options, select;
      select = $(el);
      options = select.find("option");
      if (options.size() === 1) {
        $(options[0]).select();
      }
      options = {
        placeholder: select2_localization[window.locale],
        allowClear: true
      };
      options.ajax = {
        url: select.data("source"),
        dataType: "json",
        quietMillis: 100,
        data: function(term, page) {
          return {
            q: $.trim(term),
            page: page,
            per: 10
          };
        },
        results: function(data, page) {
          var more;
          more = void 0;
          more = (page * 10) < data.total;
          return {
            results: data.records,
            more: more
          };
        }
      };
      options.dropdownCssClass = "bigdrop";
      options.initSelection = function(element, callback) {
        if (element.val().length > 0) {
          return $.getJSON(select.data("source") + "/" + element.val(), {}, function(data) {
            return callback({
              id: data.id,
              text: data.text
            });
          });
        }
      };
      return select.select2(options);
    };
  });

}).call(this);


