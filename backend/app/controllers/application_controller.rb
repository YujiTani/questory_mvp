class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  before_action :basic_auth
  before_action :generate_response_id

  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from StandardError, with: :handle_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::StatementInvalid, with: :handle_statement_invalid

  # ログ追跡用のresponse_idを生成する
  def generate_response_id
    @response_id = SecureRandom.uuid
  end

  private

  # basic認証
  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  # レコードが見つからない場合のエラーハンドリング
  def handle_record_not_found(exception)
    render json: { ok: false, response_id: @response_id, errors: exception.message }, status: :not_found
  end

  # # レコードが無効な場合のエラーハンドリング
  def handle_record_invalid(exception)
    render json: { ok: false, response_id: @response_id, errors: exception.record.errors.full_messages },
           status: :unprocessable_entity
  end

  # # 引数が無効な場合のエラーハンドリング
  def handle_argument_error(exception)
    render json: { ok: false, response_id: @response_id, message: exception.message }, status: :bad_request
  end

  # ステートメントが無効な場合のエラーハンドリング
  def handle_statement_invalid(exception)
    render json: { ok: false, response_id: @response_id, errors: exception.message }, status: :unprocessable_entity
  end

  # # 標準エラーのエラーハンドリング
  def handle_standard_error(exception)
    Rails.logger.error(exception.message)
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: { ok: false, response_id: @response_id, message: '内部サーバーエラーが発生しました。' }, status: :internal_server_error
  end
end
