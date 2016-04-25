//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require select2
//= require js-routes
//= require_tree .

$(function() {
  $('.chosen-select').select2({
    theme: 'bootstrap'
  });

  $('.task-state-select').on('change', function() {
    var id = this.id.replace('task-state-select-', '');
    return $.post({
      url: Routes.change_state_user_task_path(id),
        data: {
          task: {
            state: this.value
          }
        },
        dataType: "json"
    });
  });
});