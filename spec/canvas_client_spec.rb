require 'spec_helper'

describe Canvas::Client do

  context '#configuration' do
    
    before do
      @client = Canvas::Client.new
    end
    
    it 'should set the Canvas URL' do
      @client.url.must_equal ENV['CANVAS_URL']
      @client.url = 'bob'
      @client.url.must_equal 'bob'
    end
    
    it 'should set the Canvas OAuth2 Token' do
      @client.token.must_equal ENV['CANVAS_TOKEN']
      @client.token = 'bob'
      @client.token.must_equal 'bob'
    end

    it 'should set the Canvas Account' do
      @client.account.must_equal ENV['CANVAS_ACCOUNT']
      @client.account = 'bob'
      @client.account.must_equal 'bob'
    end
        
  end
  
  context '#broken configuration' do
    before do
      @client = Canvas::Client.new
    end
    it 'should not do request without url' do
      @client.url = nil
      lambda {
        @client.get 'accounts/1/users'
      }.must_raise Canvas::Client::ConfigurationError
    end
    it 'should not do request without token' do
      @client.token = nil
      lambda {
        @client.get 'accounts/1/users'
      }.must_raise Canvas::Client::ConfigurationError
    end
  end
  
  context '#request' do

    before do
      @client = Canvas::Client.new 
    end
    
    it 'should execute GET request from Canvas::Client' do
      VCR.use_cassette('test_request_get') do
        response = @client.get 'accounts/1/users'
        response.first['id'].must_equal 1
      end
    end
    
    it 'should execute GET request with params' do
      VCR.use_cassette('test_request_get_params') do
        response = @client.get 'accounts/1/users', page: 2, per_page: 10
        response.must_be_empty
      end
    end
    
    it 'should execture PUT request on Canvas::Client' do
      VCR.use_cassette('test_request_put') do
        response = @client.put 'users/1', { user: { name: 'Billy Bob'} }
        response['name'].must_equal 'Billy Bob'
      end
    end
    
    it 'should POST through Canvas::Client' do
      VCR.use_cassette('test_request_post') do
        params = {
          user: {
            name: 'Bob Martin',
            terms_of_use: true,
          },
          pseudonym: {
            unique_id: 'bob@martin.com',
            sis_user_id: 2
          },
          communication_channel: {
            type: 'email',
            address: 'bob@martin.com'
          }
        }
        response = @client.post 'accounts/1/users', params
        response['id'].must_equal 2
      end
    end

    it 'should DELETE through Canvas::Client' do
      VCR.use_cassette('test_request_delete') do
        response = @client.delete 'accounts/1/users/2'
        response['id'].must_equal 2
      end      
    end
    
    it 'should load a single user with search term' do
      VCR.use_cassette('test_request_user_search') do
        response = @client.get 'accounts/1/users', search_term: '1'
        user = response.first
        user['name'].must_equal 'Billy Bob'
      end
    end
  end
  
end