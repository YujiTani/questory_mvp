module Api
  class HomeController < BaseController
    def index
      render json: { message: "Welcome to the API!" }
    end
  end
end
