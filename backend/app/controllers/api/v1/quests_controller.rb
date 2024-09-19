class Api::V1::QuestsController < Api::V1::BaseController
  # すべてのメソッドであらかじめrequest_idを生成する
  before_action :set_request_id, only: [:index, :create, :update, :destroy, :trashed]

  def index
    all_quests = Quest.all.without_deleted
    # limit,offsetを受け取った場合はその値を使用する
    limit = params[:limit] || 50
    offset = params[:offset] || 0

    # limit, offsetを使って、questsを絞り込む
    quests = all_quests.limit(limit).offset(offset)

    render json: {
      ok: true,
      request_id: @request_id,
      quests: quests,
      total: all_quests.count,
      limit: limit,
      offset: offset,
    }, status: :ok

  rescue => e
    logger.error "Error in QuestsController#index: #{e.message}"
    render json: {
      ok: false,
      request_id: @request_id,
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
        request_id: @request_id,
        quest: quest
      }, status: :ok
    else
      render json: {
        ok: false,
        request_id: @request_id,
        code: "ParameterError",
        message: "パラメーターエラー （必須パラメーターを渡さなかった・パラメーターのデータ型を間違えた等）",
        errors: quest.errors.full_messages
      }, status: :bad_request
    end
  end


  def update
    quest = Quest.find_by(id: quest_params[:id])

    if quest.update(quest_params)
      render json: {
        ok: true,
        request_id: @request_id,
        quest: quest
      }
    else
      render json: {
        ok: false,
        request_id: @request_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: quest.errors
      }
    end
  end

  def destroy
    quest = Quest.find_by(id: quest_params[:id])

    if quest.soft_delete
      render json: {
        ok: true,
        request_id: @request_id,
      }
    else
      render json: {
        ok: false,
        request_id: @request_id,
        code: "NotFound",
        message: "エラーの詳細メッセージ",
        errors: quest.errors
      }
    end
  end

  def trashed
    quest = Quest.find_by(id: quest_params[:id])

    if quest.destroy
      render json: {
        ok: true,
        request_id: @request_id,
      }
    else
      render json: {
        ok: false,
        request_id: @request_id,
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

  def set_request_id
    @request_id = SecureRandom.uuid
  end
end
