class Api::V1::CoursesController < Api::V1::BaseController
  before_action :set_course_by_uuid, only: [:show, :update, :destroy]

  def create
    @course = Course.new(course_params)

    if @course.save!
      render json: {
        ok: true,
        response_id: @response_id,
        course: @course
      }, status: :ok
    end
  end

  def update
    if @course.update!(course_params)
      render json: {
        ok: true,
        response_id: @response_id,
        course: @course
      }, status: :ok
    end
  end

  def destroy
    if @course.soft_delete
      render json: {
        ok: true,
        response_id: @response_id,
        course: @course
      }, status: :ok
    end
  end

  def restore
    if @course.restore
      render json: {
        ok: true,
        response_id: @response_id,
        course: @course
      }, status: :ok
    end
  end

  def trashed
    if @course.destroy
      render json: {
        ok: true,
        response_id: @response_id,
        course: @course
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
