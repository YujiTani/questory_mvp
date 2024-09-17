class Api::V1::QuestsController < Api::V1::BaseController
  def index
    quests = Quest.all.without_deleted
    total = Quest.all_count
    # limit,offsetを受け取った場合はその値を使用する
    limit = params[:limit] || 50
    offset = params[:offset] || 0

    render json: {
      ok: true,
      request_id: SecureRandom.uuid,
      quests: quests,
      total: total,
      limit: limit,
      offset: offset,
      has_more: quests.has_more?(offset)
    }

  rescue => e
    logger.error "Error in QuestsController#index: #{e.message}"
    render json: {
      ok: false,
      request_id: SecureRandom.uuid,
      code: "InternalServerError",
      message: "エラーの詳細メッセージ",
      errors: e.message
    }, status: :internal_server_error
  end

  def create
    quest = Quest.new(quest_params)

    if quest.save
      render json: {
        ok: true,
        request_id: SecureRandom.uuid,
        quest: quest
      }
    else
      render json: {
        ok: false,
        request_id: SecureRandom.uuid,
        code: "ParameterError",
        message: "パラメーターエラー （必須パラメーターを渡さなかった・パラメーターのデータ型を間違えた等）",
        errors: quest.errors
      }
    end
  end


  def update
    quest = Quest.find_by(id: quest_params[:id])
    request_id = SecureRandom.uuid

    if quest.update(quest_params)
      render json: {
        ok: true,
        request_id: request_id,
        quest: quest
      }
    else
      render json: {
        ok: false,
        request_id: request_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: quest.errors
      }
    end
  end

  def destroy
    quest = Quest.find_by(id: quest_params[:id])
    request_id = SecureRandom.uuid

    if quest.soft_delete
      render json: {
        ok: true,
        request_id: request_id,
      }
    else
      render json: {
        ok: false,
        request_id: request_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: quest.errors
      }
    end
  end

  def trashed
    quest = Quest.find_by(id: quest_params[:id])
    request_id = SecureRandom.uuid

    if quest.destroy
      render json: {
        ok: true,
        request_id: request_id,
      }
    else
      render json: {
        ok: false,
        request_id: request_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: quest.errors
      }
    end
  end

  private

  def quest_params
    params.require(:quest).permit(:name, :description, :state)
  end
end
