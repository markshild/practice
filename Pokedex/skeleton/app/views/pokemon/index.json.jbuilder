json.array! @pokemon do |pkn|
  json.partial! 'pokemon/pokemon', pokemon: pkn, display_toys: false
end
