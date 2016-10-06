class Modele < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :nom => :title,
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
    title.nil? ? "" : title
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  private

    def slug_candidates
      [
          :title,
          [:title, :id]
      ]
    end

end
