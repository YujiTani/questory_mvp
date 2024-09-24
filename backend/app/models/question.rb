class Question < ApplicationRecord
  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # stage_id     :bigint           null: true
  # title        :string(255)      not null
  # body         :string(255)      not null
  # answer       :string(255)      not null
  # category     :integer          not null
  # explanation  :text(65535)
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_questions_on_stage_id
  # index_questions_on_uuid
  #
  # foreign_key: :stage_id

  enum :category, { choice: 0, multiple: 1, assembly: 2 }

  belongs_to :stage, optional: true

  before_validation :set_default_values, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :stage, presence: true, if: :stage_id?
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 255 }
  validates :answer, presence: true, length: { maximum: 255 }
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :explanation, length: { maximum: 1000 }

  def soft_delete
    update!(deleted_at: Time.current)
  end

  def restore
    update!(deleted_at: nil)
  end

  # ステージに紐づける
  def associate_stage(stage)
    update!(stage:)
  end

  # ステージの紐づけを解除
  def unassociate_stage
    update!(stage: nil)
  end

  # TODO: categoryによって、処理方法を変える
  # まずは選択式から実装する
  # choice multiple は falseAnswer と紐づける
  # assembly は word と紐づける

  scope :without_deleted, -> { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

  private

  def set_default_values
    self.uuid = SecureRandom.uuid
    self.category ||= :choice
  end
end
