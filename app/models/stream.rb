class Stream

  def self.find(id)
    resp = get(stream_url(id.to_s))
    data = Oj.load(resp)
    self.new data["data"]
  end

  def self.where(query)
    resp = get("#{stream_index_url}?#{query}")
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

  def toc
    @data.toc
  end

  def large_image_url
    @data.large_image_url
  end

  def home_url
    @data.home_url
  end

  class << self

    def valobox_url
      case ENV['RACK_ENV']
      when 'production'
        'https://valobox.com'
      when 'staging'
        'https://staging.valobox.com'
      when 'development'
        'http://valobox.dev'
      end
    end

    def tornado_url
      "#{valobox_url}/tornado"
    end

    def reader_url
      "#{valobox_url}/read"
    end

    def stream_index_url
      File.join(tornado_url, "v1/streams")
    end

    def stream_url(id)
      File.join(stream_index_url, id)
    end

    def embed_script
      "#{reader_url}/api.js"
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