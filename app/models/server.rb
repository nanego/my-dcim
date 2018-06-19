class Server < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model

  belongs_to :frame
  has_one :bay, through: :frame
  has_one :room, through: :frame
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :cluster
  belongs_to :server_state

  has_one :maintenance_contract
  has_many :memory_components
  has_many :disks

  has_many :slots
  has_many :cards, -> { joins(:composant).includes(:composant) }
  has_many :card_types, through: :cards
  has_many :ports, through: :cards

  has_many :moves, as: :moveable, dependent: :destroy

  has_many :documents

  validates_presence_of :numero
  validates_uniqueness_of :numero
  validate :numero_cannot_be_a_current_server_name

  accepts_nested_attributes_for :cards,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :disks,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :memory_components,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  accepts_nested_attributes_for :documents,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

  scope :sorted, -> { order( :position => :desc) }

  scope :no_pdus, -> { joins(:modele => :category).where("categories.name<>'Pdu'") }
  scope :only_pdus, -> { joins(:modele => :category).where("categories.name='Pdu'").order(:name) }

  validates :frame_id, presence: true
  validates :modele_id, presence: true
  validates :name , presence: true

  def to_s
    name.to_s
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def is_a_pdu?
    modele.is_a_pdu?
  end

  def is_not_a_pdu?
    !is_a_pdu?
  end

  def ports_per_type
    # Number of ports per type
    sums = {'XRJ' => 0,'RJ' => 0,'FC' => 0,'IPMI' => 0}
    cards.each do |card|
      if card.composant.name == 'IPMI'
        port_type = 'IPMI'
      else
        port_type = card.card_type.port_type.name
      end
      sums[port_type] = sums[port_type].to_i + card.ports.map{ |port| port.connection.try(:cable) }.compact.size
    end
    sums
  end

  def create_missing_ports
    cards.each { |card| card.create_missing_ports}
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end

    def numero_cannot_be_a_current_server_name
      servers = Server.friendly.where(slug: numero.to_s.downcase) - [self]
      if servers.present?
        errors.add(:numero, "ne peut pas être identique à un nom de machine")
      end
    end

end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end
