class Api::V1::CoursesController < Api::V1::BaseController
  before_action :set_course_by_uuid, only: [:show, :update, :destroy]

  # POST /api/v1/courses
  # コースを作成
  def create
    @course = Course.new(course_params)

    if @course.save!
      render json: {
        ok: true,
        response_id: @response_id,
        course: CourseSerializer.new(@course)
      }, status: :ok
    end
  end

  # PATCH /api/v1/courses/:uuid
  # コースを更新
  def update
    if @course.update!(course_params)
      render json: {
        ok: true,
        response_id: @response_id,
        course: CourseSerializer.new(@course)
      }, status: :ok
    end
  end
  # クエストに紐づくコース一覧を取得
  def courses
    @courses = @quest.courses.without_deleted
    serialized_courses = @courses.map { |course| CourseSerializer.new(course) }

    render json: {
      ok: true,
      response_id: @response_id,
      courses: serialized_courses
    }, status: :ok
  end

  def destroy
    if @course.soft_delete
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  def restore
    if @course.restore
      render json: {
        ok: true,
        response_id: @response_id,
        course: CourseSerializer.new(@course)
      }, status: :ok
    end
  end

  def trashed
    if @course.destroy
      render json: {
        ok: true,
        response_id: @response_id,
      }, status: :ok
    end
  end

  private

  def set_course_by_uuid
    @course = Course.find_by(uuid: params[:uuid])

    if @course.nil?
      render json: {
        ok: false,
        response_id: @response_id,
        code: "NotFound",
        message: "コースが見つかりませんでした",
      }, status: :not_found
    end
  end

  def course_params
    params.require(:course).permit(:name, :description, :difficulty)
  end
end
