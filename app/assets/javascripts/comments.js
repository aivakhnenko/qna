document.addEventListener('turbolinks:load', watchCommentsForDocument)

function watchCommentsForDocument(){
  watchComments(document);
}

function watchComments(area){
  area.querySelectorAll('.comments').forEach(function (block){
    var stream = block.dataset.commentable + '/comments';
    var commentsList = block.querySelector('.comments-list');
    App.cable.subscriptions.create('CommentsChannel', {
      connected: function(){
        this.perform('follow', { stream: stream });
      },
      received: function(data){
        commentsList.insertAdjacentHTML('beforeend', '<p>' + data.text + '</p>');
      }
    });
  });
}