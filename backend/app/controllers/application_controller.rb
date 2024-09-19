class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :basic_auth

  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from StandardError, with: :handle_standard_error

  # ログ追跡用のresponse_idを生成する
  def generate_response_id
    @response_id = SecureRandom.uuid
  end

  private

  # basic認証
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  # レコードが無効な場合のエラーハンドリング
  def handle_record_invalid(exception)
    render json: { ok: false, response_id: @response_id, errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  # 引数が無効な場合のエラーハンドリング
  def handle_argument_error(exception)
    render json: { ok: false, response_id: @response_id, message: exception.message }, status: :bad_request
  end

  # 標準エラーのエラーハンドリング
  def handle_standard_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: { ok: false, response_id: @response_id, message: "内部サーバーエラーが発生しました。" }, status: :internal_server_error
  end
end
