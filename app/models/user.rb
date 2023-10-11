# frozen_string_literal: true

class User < ApplicationRecord
  enum role: [:user, :vip, :admin]

  acts_as_token_authenticatable
  has_changelog

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:openid_connect]

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def to_s
    name.present? ? name : email.to_s
  end
end
