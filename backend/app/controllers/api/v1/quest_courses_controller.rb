class Api::V1::QuestCoursesController < Api::V1::BaseController

  # GET /api/v1/quests/:quest_uuid/courses
  # クエストに紐づくコース一覧を取得
  def index
    all_courses = Quest.find_by(uuid: params[:quest_uuid]).courses.without_deleted
    limit = params[:limit] || 50
    offset = params[:offset] || 0
    @courses = all_courses.limit(limit).offset(offset)

    render json: {
      ok: true,
      response_id: @response_id,
      courses: @courses,
      total: all_courses.count,
      limit: limit,
      offset: offset,
    }, status: :ok
  end

  # PATCH /api/v1/quests/:quest_uuid/courses/:uuid
  # 指定クエストにコースを紐付ける
  def update
    course_uuids = params[:course_uuids]
    courses = course_uuids.map { |uuid| Course.find_by(uuid: uuid) }

    courses.map { |course| course.associate_quest(quest) }

    render json: {
      ok: true,
      response_id: @response_id,
    }, status: :ok
  end

  # DELETE /api/v1/quests/:quest_uuid/courses/:uuid
  # 指定クエストに紐づくコースを解除
  def destroy
    course = Course.find_by(uuid: params[:uuid])
    course.unassociate_quest

    render json: {
      ok: true,
      response_id: @response_id,
    }, status: :ok
  end
end
