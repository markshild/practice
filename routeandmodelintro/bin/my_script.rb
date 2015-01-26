require 'addressable/uri'
require 'rest-client'

def create_user
  url = Addressable::URI.new(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/users.html',
    # query_values: {
    #   'thing1' => 'other thing',
    #   'thing2' => 'other thin',
    #   'thing3' => 'other thi',
    #   'thin[how_the_hell]' => 'other thi'
    # }
  ).to_s



  puts RestClient.post(url,
    { user: { name: "Gizmo", email: "gizmo@gizmo.gizmo" } }
    )
end
