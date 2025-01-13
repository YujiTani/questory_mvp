# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def self.up
    change_column :users, :email, :string, default: ""

    change_table :users do |t|
      ## Required
      t.string :provider, :null => false
      t.string :uid, :null => false, :default => ""

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps null: false


      ## Tokens
      t.json :tokens

      ## 初期のmigrationで作成しているので、下記カラムは不要
      # t.string :name
      # t.string :email
      # t.timestamps

    end

    add_index :users, [:uid, :provider],     unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  def self.down
    # Emailカラムのデフォルト値を元に戻す
    change_column_default :users, :email, nil

    # インデックスを削除（存在する場合のみ）
    remove_index :users, [:uid, :provider] if index_exists?(:users, [:uid, :provider])
    # remove_index :users, :reset_password_token if index_exists?(:users, :reset_password_token)
    # remove_index :users, :confirmation_token if index_exists?(:users, :confirmation_token)
    # remove_index :users, :unlock_token if index_exists?(:users, :unlock_token)

    # Devise関連のカラムを削除
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :encrypted_password
    remove_column :users, :tokens
    # remove_column :users, :reset_password_token
    # remove_column :users, :reset_password_sent_at
    # remove_column :users, :remember_created_at
    # remove_column :users, :sign_in_count
    # remove_column :users, :current_sign_in_at
    # remove_column :users, :last_sign_in_at
    # remove_column :users, :current_sign_in_ip
    # remove_column :users, :last_sign_in_ip
    # remove_column :users, :confirmation_token
    # remove_column :users, :confirmed_at
    # remove_column :users, :confirmation_sent_at
    # remove_column :users, :unconfirmed_email
    # remove_column :users, :failed_attempts
    # remove_column :users, :unlock_token
    # remove_column :users, :locked_at
  end
end
