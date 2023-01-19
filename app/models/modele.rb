# frozen_string_literal: true

class Modele < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :name => :name,
      :categorie => :category,
      :nb_elts => :nb_elts
  }

  has_many :servers, dependent: :restrict_with_error
  has_many :enclosures, dependent: :restrict_with_error
  has_many :composants, through: :enclosures

  belongs_to :manufacturer, optional: true
  belongs_to :architecture, optional: true
  belongs_to :category, optional: true

  accepts_nested_attributes_for :enclosures,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  scope :with_servers, -> { joins(:servers).uniq }

  def to_s
    name.to_s
  end

  def is_a_pdu?
    category.pdu?
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_brand
    if manufacturer.present?
      "#{manufacturer} #{name}"
    else
      "#{name}"
    end
  end

  def self.all_sorted
    Modele.includes(:manufacturer).all.sort{|f1,f2|f1.name_with_brand.capitalize <=> f2.name_with_brand.capitalize}
  end

  def self.all_sorted_with_servers
    Modele.includes(:manufacturer).with_servers.sort{|f1,f2|f1.name_with_brand.capitalize <=> f2.name_with_brand.capitalize}
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end
end
