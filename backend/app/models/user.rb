class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  include DeviseTokenAuth::Concerns::User

  # == Schema Information
  #
  # id           :bigint           not null, primary key
  # uuid         :uuid             not null
  # name         :string(255)
  # email        :string(255)
  # created_at   :datetime         not null
  # updated_at   :datetime         not null
  # deleted_at   :datetime
  #
  # Indexes
  # index_users_on_email
  # index_users_on_uuid
  #
  # foreign_key: :user_id
  #

  belongs_to :ranking, dependent: :destroy
  belongs_to :user_high_score, dependent: :destroy
  belongs_to :user_feedback, dependent: :destroy

  validates :uuid, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }

end
