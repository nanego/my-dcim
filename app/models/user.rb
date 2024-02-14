# frozen_string_literal: true

class User < ApplicationRecord
  enum role: [:user, :vip, :admin]

  acts_as_token_authenticatable
  has_changelog skip: %i[sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

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

  def regenerate_authentication_token!
    update!(authentication_token: generate_authentication_token(token_generator))
  end
end
