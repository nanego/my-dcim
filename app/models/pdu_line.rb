class PduLine < ActiveRecord::Base

  belongs_to :pdu
  has_many :pdu_outlet_groups

end
