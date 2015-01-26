Pokedex.RootView.prototype.createPokemon = function (attrs, callback) {
  var newPoke = new Pokedex.Models.Pokemon(attrs);
  var that = this;
  newPoke.save({}, {
  success: function () {
    that.pokes.add(newPoke);
    that.addPokemonToList(newPoke);
    callback(newPoke);
  }
  })

};

Pokedex.RootView.prototype.submitPokemonForm = function (event) {
  event.preventDefault();
  var $newPokeForm = $(event.target);
  var newPokeAttrs = $newPokeForm.serializeJSON();
  this.createPokemon(newPokeAttrs, this.renderPokemonDetail.bind(this));
};
