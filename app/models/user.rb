# frozen_string_literal: true

class User < ApplicationRecord
  AVAILABLE_LOCALES = I18n.available_locales.map(&:to_s).freeze
  AVAILABLE_THEMES = %w[auto dark light].freeze
  AVAILABLE_ITEMS_PER_PAGE = [25, 50, 100, 150, 200].freeze
  DEFAULT_ITEMS_PER_PAGE = 100
  AVAILABLE_BAY_BACKGROUND_COLORS = %w[modele gestion cluster].freeze
  AVAILABLE_BAY_ORIENTATIONS = %w[front back].freeze

  enum :role, { reader: 0, writer: 1 }

  acts_as_token_authenticatable
  has_changelog except: %i[sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :omniauth_providers => [:openid_connect]

  store_attribute :settings, :locale, :string, default: I18n.locale.to_s
  store_attribute :settings, :theme, :string, default: AVAILABLE_THEMES.first
  store_attribute :settings, :visualization_bay_default_background_color, :string, default: AVAILABLE_BAY_BACKGROUND_COLORS.first
  store_attribute :settings, :visualization_bay_default_orientation, :string, default: AVAILABLE_BAY_ORIENTATIONS.first
  store_attribute :settings, :items_per_page, :integer, default: DEFAULT_ITEMS_PER_PAGE

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :locale, inclusion: { in: AVAILABLE_LOCALES }, allow_nil: true
  validates :theme, inclusion: { in: AVAILABLE_THEMES }, allow_nil: true
  validates :items_per_page, inclusion: { in: AVAILABLE_ITEMS_PER_PAGE }, allow_nil: true
  validates :visualization_bay_default_background_color, inclusion: { in: AVAILABLE_BAY_BACKGROUND_COLORS }, allow_nil: true
  validates :visualization_bay_default_orientation, inclusion: { in: AVAILABLE_BAY_ORIENTATIONS }, allow_nil: true

  scope :admin, -> { where(is_admin: true) }
  scope :unsuspended, -> { where(suspended_at: nil) }
  scope :suspended, -> { where.not(suspended_at: nil) }

  alias_attribute :admin?, :is_admin

  def to_s
    name.presence || email.to_s
  end

  def regenerate_authentication_token!
    update!(authentication_token: generate_authentication_token(token_generator))
  end

  def active_for_authentication?
    return false if suspended?

    super
  end

  def inactive_message
    return :suspended if suspended?

    super
  end

  def suspended?
    suspended_at?
  end

  def suspend!
    update!(suspended_at: Time.zone.now)
  end

  def unsuspend!
    update!(suspended_at: nil)
  end
end
