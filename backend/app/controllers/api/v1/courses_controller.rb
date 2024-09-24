class Api::V1::CoursesController < Api::V1::BaseController
  before_action :set_course_by_uuid, only: [:update, :destroy, :restore, :trashed, :associate_stages]

  # POST /api/v1/courses
  # コースを作成
  def create
    @course = Course.new(course_params)

    return unless @course.save!

    render json: {
      ok: true,
      response_id: @response_id,
      course: @course
    }, status: :ok
  end

  # PATCH /api/v1/courses/:uuid
  # コースを更新
  def update
    return unless @course.update!(course_params)

    render json: {
      ok: true,
      response_id: @response_id,
      course: @course
    }, status: :ok
  end

  # PATCH /api/v1/courses/:uuid/associate_stages
  # コースにステージを紐づけ
  def associate_stages
    stage_uuids = params[:stage_uuids]
    stages = stage_uuids.map { |uuid| Stage.find_by(uuid:) }

    stages.map { |stage| stage.associate_course(@course) }

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # DELETE /api/v1/courses/:uuid
  # コースを論理削除
  def destroy
    return unless @course.soft_delete

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  # PUT /api/v1/courses/:uuid/restore
  # コースを論理削除を元に戻す
  def restore
    return unless @course.restore

    render json: {
      ok: true,
      response_id: @response_id,
      course: @course
    }, status: :ok
  end

  # DELETE /api/v1/courses/:uuid/trashed
  # コースを完全削除
  def trashed
    return unless @course.destroy

    render json: {
      ok: true,
      response_id: @response_id
    }, status: :ok
  end

  private

  def set_course_by_uuid
    @course = Course.find_by(uuid: params[:uuid])

    return unless @course.nil?

    render json: {
      ok: false,
      response_id: @response_id,
      message: 'コースが見つかりませんでした'
    }, status: :not_found
  end

  def course_params
    params.require(:course).permit(:name, :description, :difficulty)
  end
end
