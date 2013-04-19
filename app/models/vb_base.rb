class VbBase

  class << self

    def timeout
      2
    end

    def get(url, options = {})
      options[:timeout] ||= timeout

      # Setup the request url and headers
      curl = Curl::Easy.new(url) do |req|
        req.timeout = options[:timeout]
      end

      # Make the request
      curl.http_get
      
      # Return a rack response array
      raise curl.body_str unless curl.response_code == 200
      curl.body_str
    end

    def post(url, fields = [], options = {})
      options[:timeout] ||= timeout

      # Setup the request url and headers
      curl = Curl::Easy.new(url) do |req|
        req.timeout = options[:timeout]
      end

      # Make the request
      curl.http_post( fields )
      
      # Return a rack response array
      raise curl.body_str unless curl.response_code == "200"
      Hashie::Mash.new curl.body_str
    end

    def put(url, fields = [], options = {})
      fields << Curl::PostField.content(:_method, :put) 
      post(url, fields, options)
    end

    def delete(url, options = {})
      options[:timeout] ||= timeout

      # Setup the request url and headers
      curl = Curl::Easy.new(url) do |req|
        req.timeout = options[:timeout]
      end

      # Make the request
      curl.http_delete
      
      # Return a rack response array
      raise curl.body_str unless curl.response_code == "200"
      Hashie::Mash.new curl.body_str
    end
  end
end