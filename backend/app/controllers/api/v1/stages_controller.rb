class Api::V1::StagesController < Api::V1::BaseController
  before_action :set_stage_by_uuid, only: [:update, :destroy, :restore, :trashed]

  # POST /api/v1/stages
  # ステージを作成
  def create
    @stage = Stage.new(stage_params)

    if @stage.save!
      render json: {
        ok: true,
        response_id: @response_id,
        stage: @stage
      }, status: :ok
    end
  end

  # PATCH /api/v1/stages/:uuid
  # ステージを更新
  def update
    if @stage.update!(stage_params)
      render json: {
        ok: true,
        response_id: @response_id,
        stage: @stage
      }, status: :ok
    end
  end

  # DELETE /api/v1/stages/:uuid
  # ステージを論理削除
  def destroy
    if @stage.soft_delete
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  # DELETE /api/v1/stages/:uuid/restore
  # ステージを論理削除を元に戻す
  def restore
    if @stage.restore
      render json: {
        ok: true,
        response_id: @response_id,
        stage: @stage
      }, status: :ok
    end
  end

  # DELETE /api/v1/stages/:uuid/trashed
  # ステージを完全削除
  def trashed
    if @stage.destroy
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  private

  def set_stage_by_uuid
    @stage = Stage.find_by(uuid: params[:uuid])

    if @stage.nil?
      render json: {
        ok: false,
        response_id: @response_id,
        message: "ステージが見つかりませんでした",
      }, status: :not_found
    end
  end

  def stage_params
    params.require(:stage).permit(:prefix, :overview, :target, :state, :failed_case, :complete_case)
  end
end
