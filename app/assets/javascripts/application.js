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
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .
//= require bootstrap-datetimepicker
//= require bootstrap-datetimepicker/picker
//= require chosen-jquery

$(document).on('ready page:change', function() {
   $('.chosen-select').chosen({
       'allow_single_deselect': true,
       'no_results_text': '没有筛选结果',
       'width': '300px'
   });
});
