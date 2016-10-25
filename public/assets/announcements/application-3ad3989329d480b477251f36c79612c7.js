$(document).ready(function(){
  $("input#check-all-box").on("click", function(e){
    var boxes = $("input#selected_recipient_ids_");
    var original_box = this;
    boxes.each(function(i, e){
      e.checked = original_box.checked;
    });
  });
});
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
