class Quest < ApplicationRecord
  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # name         :string(255)
  # description  :text(65535)
  # state        :integer          default("draft"), not null
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_quests_on_state
  # index_quests_on_uuid
  #
  # foreign_key: :quest_id
  #
  has_many :courses

  enum state: {
    draft: 0,
    published: 1,
    archived: 2,
  }

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 60 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :state, presence: true, inclusion: { in: states.keys }

  # create メソッドや save メソッドでオブジェクトが初めてデータベースに保存される前に、実行される
  before_create :set_default_values

  private

  # デフォルト値設定メソッド
  def set_default_values
    self.uuid = SecureRandom.uuid
    self.state ||= 0
  end

  # 論理削除
  def soft_delete
    update(deleted_at: Time.current)
  end

  # 論理削除を元に戻す
  def restore
    update(deleted_at: nil)
  end

  # 削除されたレコードを除外した取得
  scope :without_deleted, -> { where(deleted_at: nil) }
  # 削除されたレコードを含めた取得
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  # 削除されたレコードのみ取得
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }
end
