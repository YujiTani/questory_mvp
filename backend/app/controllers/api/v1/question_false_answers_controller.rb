class Api::V1::QuestionFalseAnswersController < Api::V1::BaseController
  # GET /api/v1/questions/:question_uuid/false_answers
  # 質問に紐づく誤回答一覧を取得
  def index
    all_false_answers = Question.find_by(uuid: params[:question_uuid]).false_answers.without_deleted
    limit = params[:limit] || 50
    offset = params[:offset] || 0
    @false_answers = all_false_answers.limit(limit).offset(offset)

    render json: {
      ok: true,
      response_id: @response_id,
      false_answers: @false_answers,
      total: all_false_answers.count,
      limit:,
      offset:
    }, status: :ok
  rescue StandardError => e
    render json: {
      ok: false,
      response_id: @response_id,
      error: e.message
    }, status: :not_found
  end

  # DELETE /api/v1/questions/:question_uuid/false_answers/:uuid
  # 指定の問題に紐づく誤回答を解除
  def destroy
    false_answer = FalseAnswer.find_by(uuid: params[:uuid])
    false_answer.unassociate_question

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end
end
