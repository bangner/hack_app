class Public::FrontController < BaseController
  def index
    @newest_bootcamps = ::Bootcamp.newest(4)
  end
end
