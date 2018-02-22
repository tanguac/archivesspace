//= require form
//= require agents.crud
//= require agents.show
//= require merge_dropdown
//= require subrecord.crud
//= require notes.crud
//= require dates.crud
//= require related_agents.crud
//= require rights_statements.crud
//= require add_event_dropdown
//= require notes_override.crud
//= require embedded_search

$(function() {
  console.log($(this))
  $("button.preview-merge").on("click", function() {
    /*var $form = $(this).closest("form");*/
    var $form = $( "form:eq( 4 )" )
    console.log($form)
    console.log($form.attr("action") + "?dry_run=true")
    /*console.log(document.forms[4].attr("action") + "?dry_run=true")*/
    AS.openCustomModal("mergePreviewModal", $(this).text(), "<div class='alert alert-info'>Loading...</div>", {}, this);
    $.ajax({
      url: $form.attr("action") + "?dry_run=true",
      type: "POST",
      data:  $form.serializeArray(),
      success: function (html) {
        $(".alert", "#mergePreviewModal").replaceWith(AS.renderTemplate("modal_quick_template", {message: html}));
        $(window).trigger("resize");
      }
    });
  });

});
