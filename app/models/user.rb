# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def to_s
    name.present? ? name : email.to_s
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:openid_connect]
end
