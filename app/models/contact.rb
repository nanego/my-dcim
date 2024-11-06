# frozen_string_literal: true

class Contact < ApplicationRecord
  has_changelog

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
