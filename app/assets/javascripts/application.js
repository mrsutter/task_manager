//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require select2
//= require_tree .

$(function() {
  $('.chosen-select').select2({
    theme: 'bootstrap'
  });

  $('.task-state-select').on('change', function() {
    var id = this.id.replace('task-state-select-', '');
    return $.post({
      url: '/user/tasks/' + id + '/change_state',
        data: {
          task: {
            state: this.value,
          }
        },
        dataType: "json"
    });
  });
});