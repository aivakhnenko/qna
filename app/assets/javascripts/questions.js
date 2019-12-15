$(document).on('turbolinks:load', function(){
  $('.question').on('click', '.edit-question-link', function(e){
    e.preventDefault();
    $(this).hide();
    $('.question-form').removeClass('hidden');
  })

  var questions = document.querySelector('.questions');
  if (questions) {
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: function(){
        console.log('Connected!');
        this.perform('follow');
      },
      received: function(data){
        questions.insertAdjacentHTML("beforeend", data);
      }
    });
  }
});