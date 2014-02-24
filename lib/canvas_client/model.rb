require 'virtus'

class Canvas::Model
  
  include ::Virtus.model
  attribute :id, Integer

  def self.client
    Canvas.client
  end
  
  def client
    self.class.client
  end

  def persisted?
    !new_record?
  end
  
  def new_record?
    id.nil?
  end
  
  def self.find(id)
    users = client.get(base_url, search_term: id)
    return users.size == 1 ? new(users.first) : nil
  end
  
  def save(attributes={})
    self.attributes = attributes if attributes
    create or update
  end

  def destroy
    client.delete(destroy_url) and !!freeze
  end
  
  
  private
  
  def create
    if new_record?
      self.attributes = client.post create_url, create_params
      persisted?
    else
      false
    end
  end
  
  def create_params
    {}
  end
  
  def update
    if persisted?
      self.attributes = client.put update_url, update_params
      persisted?
    else
      false
    end
  end
  
  def update_params
    {}
  end
  
  def self.base_url
    raise Canvas::Client::ConfigurationError("You need to implement base_url on #{self.class.name}")
  end
  
  def base_url
    self.class.base_url
  end
  alias_method :create_url, :base_url
  
  def resource_url
    File.join base_url, id.to_s
  end
  alias_method :update_url, :resource_url
  alias_method :destroy_url, :resource_url
  
end