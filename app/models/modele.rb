class Modele < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :name => :name,
      :categorie => :category,
      :nb_elts => :nb_elts
  }

  has_many :servers
  has_many :composants, -> { order(name: :asc, position: :asc) }

  belongs_to :marque
  belongs_to :architecture
  belongs_to :category

  accepts_nested_attributes_for :composants,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  def to_s
    name.nil? ? "" : name
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def name_with_brand
    "#{marque} #{name}"
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end

end
