class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question_by_uuid, only: [:update, :destroy, :restore, :trashed]

  # POST /api/v1/questions
  # 問題を作成
  def create
    @question = Question.new(question_params)

    if @question.save!
      render json: {
        ok: true,
        response_id: @response_id,
        question: @question
      }, status: :ok
    end
  end

  # PATCH /api/v1/questions/:uuid
  # 問題を更新
  def update
    if @question.update!(question_params)
      render json: {
        ok: true,
        response_id: @response_id,
        question: @question
      }, status: :ok
    end
  end

  # DELETE /api/v1/questions/:uuid
  # 問題を論理削除
  def destroy
    if @question.destroy
      render json: {
        ok: true,
        response_id: @response_id,
        question: @question
      }, status: :ok
    end
  end

  # PUT /api/v1/questions/:uuid/restore
  # 問題を論理削除を元に戻す
  def restore
    if @question.restore
      render json: {
        ok: true,
        response_id: @response_id,
        question: @question
      }, status: :ok
    end
  end

  # DELETE /api/v1/questions/:uuid/trashed
  # 問題を完全削除
  def trashed
    if @question.destroy
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  private

  def set_question_by_uuid
    @question = Question.find_by(uuid: params[:uuid])

    if @question.nil?
      render json: {
        ok: false,
        response_id: @response_id,
        message: '問題が見つかりません'
      }, status: :not_found
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, :answer, :category, :explanation)
  end
end
