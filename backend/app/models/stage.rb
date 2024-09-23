class Stage < ApplicationRecord
  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # course_id    :bigint           null: true
  # prefix       :string(255)      not null, unique: true
  # overview     :string(255)
  # target       :string(255)
  # failed_case  :integer          default(0), not null
  # state        :integer          default(0), not null
  # complete_case: integer          default(0), not null
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_stages_on_course_id
  # index_stages_on_state
  # index_stages_on_uuid
  # index_stages_on_prefix
  #
  # foreign_key: :course_id

  enum :state, { draft: 0, published: 1, archived: 2 }

  belongs_to :course, optional: true
  has_many :questions, dependent: :nullify

  before_validation :set_default_values, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :course, presence: true, if: :course_id?
  validates :prefix, presence: true, uniqueness: true, length: { maximum: 5 }
  validates :overview, length: { maximum: 255 }
  validates :target, length: { maximum: 255 }
  validates :state, presence: true, inclusion: { in: states.keys }
  validates :failed_case, presence: true, inclusion: { in: 0..2 }
  validates :complete_case, presence: true, inclusion: { in: 0..2 }

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  def associate_stage(course)
    update!(course: course)
  end

  def unassociate_stage
    update!(course: nil)
  end

  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

  private

  def set_default_values
    self.uuid = SecureRandom.uuid
    self.state ||= 0
    self.failed_case ||= 0
    self.complete_case ||= 0
  end
end
