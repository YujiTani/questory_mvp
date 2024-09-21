class Api::V1::QuestsController < Api::V1::BaseController
  before_action :set_quest_by_uuid, only: [:update, :destroy, :trashed, :restore, :destroy]

  # GET /api/v1/quests
  # クエスト一覧を取得
  def index
    all_quests = Quest.all.without_deleted
    limit = params[:limit] || 50
    offset = params[:offset] || 0

    # limit, offsetを使って、questsを絞り込む
    @quests = all_quests.limit(limit).offset(offset)
    serialized_quests = @quests.map { |quest| QuestSerializer.new(quest) }

    render json: {
      ok: true,
      response_id: @response_id,
      quests: serialized_quests,
      total: all_quests.count,
      limit: limit,
      offset: offset,
    }, status: :ok
  end

  # POST /api/v1/quests
  # クエストを作成
  def create
    @quest = Quest.new(quest_params)

    if @quest.save!
      render json: {
        ok: true,
        response_id: @response_id,
        quest: QuestSerializer.new(@quest)
      }, status: :ok
    end
  end

  # PATCH /api/v1/quests/:uuid
  # クエストを更新
  def update
    if @quest.update!(quest_params)
      render json: {
        ok: true,
        response_id: @response_id,
        quest: QuestSerializer.new(@quest)
      }, status: :ok
    end
  end

  # DELETE /api/v1/quests/:uuid
  # クエストを論理削除
  def destroy
    if @quest.soft_delete
      render json: {
        ok: true,
        response_id: @response_id,
      }
    end
  end

  # DELETE /api/v1/quests/:uuid/restore
  # クエストを論理削除を元に戻す
  def restore
    if @quest.restore
      render json: {
        ok: true,
        response_id: @response_id,
        quest: QuestSerializer.new(@quest)
      }, status: :ok
    end
  end

  # DELETE /api/v1/quests/:uuid/trashed
  # クエストを完全削除
  def trashed
    if @quest.destroy
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  private

  def set_quest_by_uuid
    @quest = Quest.find_by(uuid: params[:uuid])

    if @quest.nil?
      render json: {
        ok: false,
        response_id: @response_id,
        code: "NotFound",
        message: "クエストが見つかりませんでした",
      }, status: :not_found
    end
  end

  def quest_params
    params.require(:quest).permit(:name, :description, :state)
  end
end
