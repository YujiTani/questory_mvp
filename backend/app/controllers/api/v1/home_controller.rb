module Api
  class Api::V1::HomeController < Api::V1::BaseController
    def index
      render json: { message: 'Welcome to the API!' }
    rescue StandardError => e
      logger.error "Error in HomeController#index: #{e.message}"
      render json: {
        ok: false,
        request_id: SecureRandom.uuid,
        code: 'InternalServerError',
        message: 'エラーの詳細メッセージ',
        errors: e.message
      }, status: :internal_server_error
    end
  end
end
