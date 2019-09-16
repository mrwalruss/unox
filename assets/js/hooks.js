import { notify } from './notifications'

const getGameName = () => document.getElementById('game').getAttribute('data-game-name')

const notifyTurn = {
  updated() {
    if (this.el.classList.contains('you')) {
      notify('It\' your turn to play!', { body: `on ${getGameName()}`})
    }
  }
}

export default {
  notifyTurn,
}
