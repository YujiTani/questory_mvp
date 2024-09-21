class Api::V1::QuestsController < Api::V1::BaseController
  before_action :set_quest_by_uuid, only: [:update, :destroy, :trashed, :restore, :destroy]

  def index
    all_quests = Quest.all.without_deleted
    limit = params[:limit] || 50
    offset = params[:offset] || 0

    # limit, offsetを使って、questsを絞り込む
    @quests = all_quests.limit(limit).offset(offset)

    render json: {
      ok: true,
      response_id: @response_id,
      quests: @quests,
      total: all_quests.count,
      limit: limit,
      offset: offset,
    }, status: :ok
  end

  def create
    @quest = Quest.new(quest_params)

    if @quest.save!
      render json: {
        ok: true,
        response_id: @response_id,
        quest: @quest
      }, status: :ok
    end
  end


  def update
    if @quest.update!(quest_params)
      render json: {
        ok: true,
        response_id: @response_id,
        quest: @quest
      }, status: :ok
    end
  end

  def destroy
    if @quest.soft_delete
      render json: {
        ok: true,
        response_id: @response_id,
        quest: @quest
      }
    else
      render json: {
        ok: false,
        response_id: @response_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: @quest.errors
      }
    end
  end

  def restore
    if @quest.restore
      render json: {
        ok: true,
        response_id: @response_id,
        quest: @quest
      }, status: :ok
    end
  end

  def trashed
    if @quest.destroy
      render json: {
        ok: true,
        response_id: @response_id,
      }
    else
      render json: {
        ok: false,
        response_id: @response_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: @quest.errors
      }
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
