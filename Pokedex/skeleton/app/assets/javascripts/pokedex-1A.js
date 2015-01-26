Pokedex.RootView.prototype.addPokemonToList = function (pokemon) {
  var $li = $('<li>');
  $li.html(pokemon.get('name') + ' ' + pokemon.get('poke_type'));
  $li.addClass('poke-list-item');
  $li.attr('data-id', pokemon.get('id'))
  this.$pokeList.append($li);
};

Pokedex.RootView.prototype.refreshPokemon = function (callback) {
  this.pokes.fetch( {
    success: function() {
      this.pokes.each(function(poke) {
        this.addPokemonToList(poke);
      }.bind(this))}.bind(this)
  })
};
