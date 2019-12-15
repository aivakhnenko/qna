document.addEventListener('turbolinks:load', votes);

function votes(){
  var links = document.querySelectorAll('.votes .unvote a, .votes .vote-up a, .votes .vote-down a');
  links.forEach(function(link) { link.addEventListener('ajax:success', vote); });

  var blocks = document.querySelectorAll('.votes');
  blocks.forEach(function(block) {
    var vote = parseInt(block.querySelector('.vote').innerHTML);
    vote_links(block, vote);
  });
}

function vote(e){
  var votes = e.detail[0];
  var block = this.closest('.votes');
  var result = block.querySelector('.result');

  vote_links(block, votes.vote);
  result.innerHTML = 'Votes: ' + votes.votes;
}

function vote_links(block, vote){
  var voted_up = block.querySelector('.voted-up');
  var voted_down = block.querySelector('.voted-down');
  var unvote = block.querySelector('.unvote');
  var vote_up = block.querySelector('.vote-up');
  var vote_down = block.querySelector('.vote-down');

  switch (vote){
    case 0:
      voted_up.classList.add('hidden');
      voted_down.classList.add('hidden');
      unvote.classList.add('hidden');
      vote_up.classList.remove('hidden');
      vote_down.classList.remove('hidden');
      break;
    case 1:
      voted_up.classList.remove('hidden');
      voted_down.classList.add('hidden');
      unvote.classList.remove('hidden');
      vote_up.classList.add('hidden');
      vote_down.classList.remove('hidden');
      break;
    case -1:
      voted_up.classList.add('hidden');
      voted_down.classList.remove('hidden');
      unvote.classList.remove('hidden');
      vote_up.classList.remove('hidden');
      vote_down.classList.add('hidden');
      break;
    default:
  }
}