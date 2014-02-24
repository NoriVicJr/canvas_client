require "canvas_client/version"

module Canvas
  
  autoload :Client, 'canvas_client/client'
  autoload :Model,  'canvas_client/model'
  autoload :User,   'canvas_client/models/user'
  autoload :Course, 'canvas_client/models/course'
  autoload :Enrollment, 'canvas_client/models/enrollment'
  
  def self.client
    @client ||= Canvas::Client.new
  end
  
  def self.client=(client)
    @client = client
  end
  
end
