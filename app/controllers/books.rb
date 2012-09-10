ApiDemo.controllers :books do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index do
    @streams = Stream.where("q=#{params[:query]}")
    render "books/index"
  end

  get :show, with: :id do
    # @stream = ValoBox::Api.find(params[:id])
    @stream = Stream.find(params[:id])
    render 'books/show'
  end

end
