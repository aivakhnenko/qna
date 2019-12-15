$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e){
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('#answer-' + answerId + ' .edit-answer-form').removeClass('hidden');
  })

  var answers = document.querySelector('.answers');
  if (answers) {
    App.cable.subscriptions.create('AnswersChannel', {
      connected: function(){
        this.perform('follow', { question_id: gon.question_id});
      },
      received: function(data){
        var answer = answer_partial_for_user(data.partial, data.answer_user_id);
        answers.appendChild(answer);
      }
    });
  }
});

function answer_partial_for_user(partial, answer_user_id){
  var answer = document.createElement('template');
  answer.innerHTML = partial;
  answer = answer.content.firstChild;
  if (gon.current_user_id == gon.question_user_id)
    answer.querySelector('.best-answer-link').classList.remove('hidden');
  else
    answer.querySelector('.best-answer-link').remove();
  if (gon.current_user_id == answer_user_id) {
    answer.querySelector('.change-answer-links').classList.remove('hidden');
    answer.querySelectorAll('.delete-link').forEach(function(link) { link.classList.remove('hidden'); });
    answer.querySelector('.votes').remove();
  }
  else {
    answer.querySelector('.change-answer-links').remove();
    answer.querySelectorAll('.delete-link').forEach(function(link) { link.remove(); });
    answer.querySelector('.votes').classList.remove('hidden');
  }
  return answer;
}