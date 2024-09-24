class Api::V1::StagesController < Api::V1::BaseController
  before_action :set_stage_by_uuid, only: [:update, :associate_questions, :destroy, :restore, :trashed]

  # POST /api/v1/stages
  # ステージを作成
  def create
    @stage = Stage.new(stage_params)

    return unless @stage.save!

    render json: {
      ok: true,
      response_id: @response_id,
      stage: @stage
    }, status: :ok
  end

  # PATCH /api/v1/stages/:uuid
  # ステージを更新
  def update
    return unless @stage.update!(stage_params)

    render json: {
      ok: true,
      response_id: @response_id,
      stage: @stage
    }, status: :ok
  end

  # PATCH /api/v1/stages/:uuid/associate_questions
  # ステージに問題を紐づけ
  def associate_questions
    question_uuids = params[:question_uuids]
    questions = question_uuids.map { |uuid| Question.find_by(uuid:) }

    questions.map { |question| question.associate_stage(@stage) }

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # DELETE /api/v1/stages/:uuid
  # ステージを論理削除
  def destroy
    return unless @stage.soft_delete

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # DELETE /api/v1/stages/:uuid/restore
  # ステージを論理削除を元に戻す
  def restore
    return unless @stage.restore

    render json: {
      ok: true,
      response_id: @response_id,
      stage: @stage
    }, status: :ok
  end

  # DELETE /api/v1/stages/:uuid/trashed
  # ステージを完全削除
  def trashed
    return unless @stage.destroy

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  private

  def set_stage_by_uuid
    @stage = Stage.find_by(uuid: params[:uuid])

    return unless @stage.nil?

    render json: {
      ok: false,
      response_id: @response_id,
      message: 'ステージが見つかりませんでした'
    }, status: :not_found
  end

  def stage_params
    params.require(:stage).permit(:prefix, :overview, :target, :state, :failed_case, :complete_case)
  end
end
