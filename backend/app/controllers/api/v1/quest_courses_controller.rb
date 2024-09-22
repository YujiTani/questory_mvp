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

  rescue => e
    render json: {
      ok: false,
      response_id: @response_id,
      error: e.message,
    }, status: :not_found
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
