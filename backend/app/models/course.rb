class Course < ApplicationRecord
  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # quest_id     :bigint           null: true
  # name         :string(255)
  # description  :text(65535)
  # difficulty   :integer          default(0), not null
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_courses_on_difficulty
  # index_courses_on_quest_id
  # index_courses_on_uuid
  #
  # foreign_key: :quest_id

  # optional: true 外部キーがnilでもエラーにしない
  belongs_to :quest, optional: true
  has_many :stages, dependent: :nullify

  # バリデーション前にデフォルト値を設定する
  before_validation :set_default_values, on: :create

  validates :uuid, presence: true, uniqueness: true
  # quest_idがnilでない場合、questが存在しなければならない
  validates :quest, presence: true, if: :quest_id?
  validates :name, length: { maximum: 60 }, allow_nil: true
  validates :description, length: { maximum: 1000 }, allow_nil: true
  validates :difficulty, presence: true, inclusion: { in: 0..2 }

  # 論理削除
  def soft_delete
    update(deleted_at: Time.current)
  end

  # 論理削除を元に戻す
  def restore
    update(deleted_at: nil)
  end

  # クエストと紐づける
  def associate_quest(quest)
    update!(quest:)
  end

  # クエストとの紐づけを解除する
  def unassociate_quest
    update!(quest: nil)
  end

  # 削除されたレコードを除外した取得
  scope :without_deleted, -> { where(deleted_at: nil) }
  # 削除されたレコードを含めた取得
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  # 削除されたレコードのみ取得
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

  private

  # デフォルト値設定メソッド
  def set_default_values
    self.uuid = SecureRandom.uuid
    self.difficulty ||= 0
  end
end
