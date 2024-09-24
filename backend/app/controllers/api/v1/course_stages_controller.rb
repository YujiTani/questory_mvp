class Api::V1::CourseStagesController < Api::V1::BaseController

  # GET /api/v1/courses/:course_uuid/stages
  # コースに紐づくステージ一覧を取得
  def index
    all_stages = Course.find_by(uuid: params[:course_uuid]).stages.without_deleted
    limit = params[:limit] || 50
    offset = params[:offset] || 0
    @stages = all_stages.limit(limit).offset(offset)

    render json: {
      ok: true,
      response_id: @response_id,
      stages: @stages,
      total: all_stages.count,
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

  # DELETE /api/v1/courses/:course_uuid/stages/:uuid
  # コースに紐づくステージを解除
  def destroy
    stage = Stage.find_by(uuid: params[:uuid])
    stage.unassociate_course

    render json: {
      ok: true,
      response_id: @response_id,
    }, status: :ok
  end
end
