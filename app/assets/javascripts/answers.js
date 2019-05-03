$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('#answer-' + answerId + ' .edit-answer-form').removeClass('hidden');
  })
});