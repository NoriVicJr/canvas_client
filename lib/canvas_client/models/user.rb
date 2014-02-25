class Canvas::User < Canvas::Model

  attribute :name, String
  attribute :sortable_name, String
  attribute :login_id, String
  attribute :short_name, String
  attribute :sis_user_id, String
  attribute :email, String

  def self.find(id)
    users = Canvas.client.get(base_url, search_term: id)
    return users.size == 1 ? new(users.first) : nil
  rescue RestClient::ResourceNotFound
    nil
  end

  def create_params
    params = {
      user: {
        name: name,
        terms_of_use: true,
      },
      pseudonym: {
        unique_id: email,
        sis_user_id: sis_user_id
      },
      communication_channel: {
        type: 'email',
        address: email
      }
    }
  end

  def update_params
    {
      user: {
        name: name,
        short_name: short_name,
        sortable_name: sortable_name
      }
    }
  end

  def self.base_url
    File.join 'accounts', Canvas.client.account, 'users'
  end

  def update_url
    File.join 'users', id.to_s
  end

end
