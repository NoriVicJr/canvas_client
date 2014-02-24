require 'rest-client'
require 'json'

module Canvas

  class Client

    class ConfigurationError < Exception
    end

    attr_accessor :url, :token, :account

    def initialize(url: nil, token: nil, account: nil)
      @url, @token, @account = url, token, account
      @url     ||= ENV['CANVAS_URL']
      @token   ||= ENV['CANVAS_TOKEN']
      @account ||= ENV['CANVAS_ACCOUNT']
    end
  
    def get(url, params={})
      request GetRequest, url, params
    end
  
    def post(url, params={})
      request PostRequest, url, params
    end

    def put(url, params={})
      request PutRequest, url, params
    end
  
    def delete(url)
      request DeleteRequest, url
    end
  
    private 

    def request(method, path, params={})
      raise ConfigurationError if token.nil? || url.nil?
      request = method.new path: path, params: params, client: self
      request.execute
    end

    class Request

      attr_accessor :method, :params, :client, :path

      def initialize(options={})
        @path, @params, @client = options.values_at :path, :params, :client
      end

      def execute
        JSON.parse response
      end

      def response
        raise 'Not implemented'
      end

      def headers
        @headers ||= { 'Authorization' => "Bearer #{client.token}", :content_type => :json, :accept => :json }
      end

      def url
        File.join(client.url, 'api', 'v1', path)
      end

    end

    class GetRequest < Request
      def response
        req = RestClient::Request.new method: :get, url: url, payload: params, headers: headers
        RestClient.get "#{url}?#{req.payload}", headers
      end
    end

    class PutRequest < Request
      def response
        RestClient.put url, params, headers
      end
    end

    class PostRequest < Request
      def response
        RestClient.post url, params, headers
      end
    end

    class DeleteRequest < Request
      def response
        RestClient.delete url, headers
      end
    end

  end

end