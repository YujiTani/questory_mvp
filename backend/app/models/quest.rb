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
  has_many :courses, dependent: :nullify

  enum :state, { draft: 0, published: 1, archived: 2 }

  # バリデーション前にデフォルト値を設定する
  before_validation :set_default_values, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :name, length: { maximum: 60 }, allow_nil: true
  validates :description, length: { maximum: 1000 }, allow_nil: true
  validates :state, presence: true, inclusion: { in: states.keys }

  # 論理削除
  def soft_delete
    update(deleted_at: Time.current)
  end

  # 論理削除を元に戻す
  def restore
    update(deleted_at: nil)
  end

  # 取得したデータ数と総数を比較して、取得するデータが残っているかどうか判定して返す
  def self.has_more?(offset)
    offset + count < Quest.all.without_deleted.count
  end

  # 削除されたレコードを除外した取得
  scope :without_deleted, -> { where(deleted_at: nil) }
  # 削除されたレコードを含めた取得
  scope :with_deleted, -> { unscope(where: :deleted_at) }
  # 削除されたレコードのみ取得
  scope :only_deleted, -> { with_deleted.where.not(deleted_at: nil) }

  private

  # デフォルト値設定メソッド
  # create メソッドや save メソッドでオブジェクトが初めてデータベースに保存される前に、実行される
  def set_default_values
    self.uuid = SecureRandom.uuid
    self.state ||= 0
  end
end
