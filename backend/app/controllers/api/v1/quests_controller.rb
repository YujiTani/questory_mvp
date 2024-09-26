class Api::V1::QuestsController < Api::V1::BaseController
  before_action :set_quest_by_uuid, only: [:update, :destroy, :trashed, :restore, :associate_courses]

  # GET /api/v1/quests
  # クエスト一覧を取得
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
      limit:,
      offset:
    }, status: :ok
  end

  # POST /api/v1/quests
  # クエストを作成
  def create
    @quest = Quest.new(quest_params)

    return unless @quest.save!

    render json: {
      ok: true,
      response_id: @response_id,
      quest: @quest
    }, status: :ok
  end

  # PATCH /api/v1/quests/:uuid
  # クエストを更新
  def update
    return unless @quest.update!(quest_params)

    render json: {
      ok: true,
      response_id: @response_id,
      quest: @quest
    }, status: :ok
  end

  # PATCH /api/v1/quests/:uuid/associate_courses
  # 指定クエストにコースを紐付ける
  def associate_courses
    course_uuids = params[:course_uuids]
    courses = course_uuids.map { |uuid| Course.find_by(uuid:) }

    courses.map { |course| course.associate_quest(@quest) }

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # DELETE /api/v1/quests/:uuid
  # クエストを論理削除
  def destroy
    return unless @quest.soft_delete

    render json: {
      ok: true,
      response_id: @response_id
    }
  end

  # PUT /api/v1/quests/:uuid/restore
  # クエストを論理削除を元に戻す
  def restore
    return unless @quest.restore

    render json: {
      ok: true,
      response_id: @response_id,
      quest: @quest
    }, status: :ok
  end

  # DELETE /api/v1/quests/:uuid/trashed
  # クエストを完全削除
  def trashed
    return unless @quest.destroy

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  private

  def set_quest_by_uuid
    @quest = Quest.find_by(uuid: params[:uuid])

    return unless @quest.nil?

    render json: {
      ok: false,
      response_id: @response_id,
      message: 'クエストが見つかりませんでした'
    }, status: :not_found
  end

  def quest_params
    params.require(:quest).permit(:name, :description, :state)
  end
end
