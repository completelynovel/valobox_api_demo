class Stream

  def self.find(id)
    resp = get("#{tornado_url}/#{id.to_s}")
    data = Oj.load(resp)
    self.new data["data"]
  end

  def self.where(query)
    resp = get("#{tornado_url}?#{query}")
    data = Oj.load(resp)
    out = []
    data["data"]["results"].values.compact.each do |stream|
      out << self.new(stream)
    end
    out
  end

  attr_accessor :data

  def initialize(hash)
    @data = Hashie::Mash.new hash
  end

  def id
    @data.id
  end

  def title
    @data.title
  end

  def about
    @data.about
  end

  def reader_url
    @data.reader_url
  end

  def embed_script
    @data.embed_script
  end

  def toc
    @data.toc
  end

  def large_image_url
    @data.large_image_url
  end

  class << self

    def tornado_url
      case ENV['RACK_ENV']
      when "production"
        "http://tornado.valobox.com/v1/streams"
      else
        "http://tornado.valobox.dev/v1/streams"
        # "http://tornado.valobox.com/v1/streams"
      end
    end

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