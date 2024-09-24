class Api::V1::FalseAnswersController < Api::V1::BaseController
  before_action :set_false_answer_by_uuid, only: [:update, :destroy, :restore, :trashed]

  # POST /api/v1/false_answers
  # 誤回答を作成
  def create
    @false_answer = FalseAnswer.new(false_answer_params)

    return unless @false_answer.save!

    render json: {
      ok: true,
      response_id: @response_id,
      false_answer: @false_answer
    }, status: :ok
  end

  # PATCH /api/v1/false_answers/:uuid
  # 誤回答を更新
  def update
    return unless @false_answer.update!(false_answer_params)

    render json: {
      ok: true,
      response_id: @response_id,
      false_answer: @false_answer
    }, status: :ok
  end

  # DELETE /api/v1/false_answers/:uuid
  # 誤回答を論理削除
  def destroy
    return unless @false_answer.soft_delete

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # PUT /api/v1/false_answers/:uuid/restore
  # 誤回答を論理削除を元に戻す
  def restore
    return unless @false_answer.restore

    render json: {
      ok: true,
      response_id: @response_id,
      false_answer: @false_answer
    }, status: :ok
  end

  # DELETE /api/v1/false_answers/:uuid/trashed
  # 誤回答を完全削除
  def trashed
    return unless @false_answer.destroy

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  private

  def set_false_answer_by_uuid
    @false_answer = FalseAnswer.find_by(uuid: params[:uuid])

    return unless @false_answer.nil?

    render json: {
      ok: false,
      response_id: @response_id,
      message: 'データが見つかりませんでした'
    }, status: :not_found
  end

  def false_answer_params
    params.require(:false_answer).permit(:answer)
  end
end
