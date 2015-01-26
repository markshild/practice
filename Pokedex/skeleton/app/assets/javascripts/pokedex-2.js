Pokedex.RootView.prototype.addToyToList = function (toy) {
  var $li = $('<li>').html('Toy Name: ' + toy.get('name') +
  ', Happiness : ' + toy.get('happiness') + ', Price :'  + toy.get('price'));
  $li.addClass('toy-list-item');
  $li.attr('data-toy-id', toy.id)
  $li.attr('data-poke-id', toy.get('pokemon_id'));
  $newUl.append($li)
};

Pokedex.RootView.prototype.renderToyDetail = function (toy) {
  var $div = $("<div>").addClass('detail');
  var $img = $('<img>').attr('src', toy.get('image_url'));
  $div.append($img);
  var $select = $('<select>').attr('data-toy-id', toy.id).attr('data-poke-id', toy.get('pokemon_id'));
  $select.addClass('select-this')
  this.pokes.each( function (poke) {
    var $option = $('<option>').attr('value', poke.id).html(poke.get('name'));
    if (toy.get('pokemon_id') === poke.id) {
      $option.prop('selected', true);
    }
    $select.append($option);
  });
  $div.append($select);
  this.$toyDetail.append($div);
};

Pokedex.RootView.prototype.selectToyFromList = function (event) {
  var $target = $(event.target);
  var currentID = $target.data('toy-id');
  var pokeID = $target.data('poke-id');
  var pokemon = this.pokes.get(pokeID);
  var toy = pokemon.toys().get(currentID);
  this.renderToyDetail(toy);
};
