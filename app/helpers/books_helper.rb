# Helper methods defined here can be accessed in any controller or view in the application

ApiDemo.helpers do
  def valobox_asset(path)
    # case ENV['PADRINO_ENV']
    # when "production"
    #   "//assets.valobox.com/#{path}"
    # else
    #   "//assets.valobox.dev/#{path}"
    # end
    path
  end
end
