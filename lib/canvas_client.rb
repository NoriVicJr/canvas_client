require "canvas_client/version"

module Canvas
  
  autoload :Client, 'canvas_client/client'
  autoload :Model,  'canvas_client/model'
  autoload :User,   'canvas_client/user'
  
  def self.client
    @client ||= Canvas::Client.new
  end
  
  def self.client=(client)
    @client = client
  end
  
end
