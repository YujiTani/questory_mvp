class FalseAnswer < ApplicationRecord
  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # question_id  :bigint           not null
  # answer       :string(255)      not null
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_false_answers_on_question_id
  # index_false_answers_on_uuid
  #
  # foreign_key: :question_id

  belongs_to :question, optional: true

  before_validation :set_default_values, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :question, presence: true, if: :question_id?
  validates :answer, presence: true, length: { maximum: 255 }

  def soft_delete
    update!(deleted_at: Time.current)
  end

  def restore
    update!(deleted_at: nil)
  end

  # 問題に紐づける
  def associate_question(question)
    update!(question:)
  end

  # 問題の紐づけを解除
  def unassociate_question
    update!(question: nil)
  end

  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

  private

  def set_default_values
    self.uuid = SecureRandom.uuid
  end
end
