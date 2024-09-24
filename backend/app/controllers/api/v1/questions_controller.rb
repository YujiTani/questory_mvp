class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question_by_uuid, only: [:update, :destroy, :restore, :trashed]

  # POST /api/v1/questions
  # 問題を作成
  def create
    @question = Question.new(question_params)

    return unless @question.save!

    render json: {
      ok: true,
      response_id: @response_id,
      question: @question
    }, status: :ok
  end

  # PATCH /api/v1/questions/:uuid
  # 問題を更新
  def update
    return unless @question.update!(question_params)

    render json: {
      ok: true,
      response_id: @response_id,
      question: @question
    }, status: :ok
  end

  # DELETE /api/v1/questions/:uuid
  # 問題を論理削除
  def destroy
    return unless @question.destroy

    render json: {
      ok: true,
      response_id: @response_id,
      question: @question
    }, status: :ok
  end

  # PUT /api/v1/questions/:uuid/restore
  # 問題を論理削除を元に戻す
  def restore
    return unless @question.restore

    render json: {
      ok: true,
      response_id: @response_id,
      question: @question
    }, status: :ok
  end

  # DELETE /api/v1/questions/:uuid/trashed
  # 問題を完全削除
  def trashed
    return unless @question.destroy

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  private

  def set_question_by_uuid
    @question = Question.find_by(uuid: params[:uuid])

    return unless @question.nil?

    render json: {
      ok: false,
      response_id: @response_id,
      message: '問題が見つかりません'
    }, status: :not_found
  end

  def question_params
    params.require(:question).permit(:title, :body, :answer, :category, :explanation)
  end
end
