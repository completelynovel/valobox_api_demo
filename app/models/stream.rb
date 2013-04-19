class Stream < VbBase

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

    def find(id)
      resp = get(stream_url(id.to_s))
      data = Oj.load(resp)
      self.new data["data"]
    end

    def where(query)
      resp = get("#{stream_index_url}?#{query}")
      data = Oj.load(resp)
      out = []
      data["data"]["results"].values.compact.each do |stream|
        out << self.new(stream)
      end
      out
    end

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
  end

end