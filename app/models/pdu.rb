class Pdu < ActiveRecord::Base

  belongs_to :frame
  has_many :pdu_lines

  def to_s
    name
  end

  def create_pdu_elements_by_cablename(cablename)
    # we expect ALIM cablenames to have this format: 'Lxxxx'. Ex: 'L3A01'
    line = cablename[2]
    group = cablename[1]
    create_pdu_elements(line, group)
  end

  def create_pdu_elements(line, group)
    self.pdu_lines << PduLine.create(name: line) if self.pdu_lines.select{|l|l.name == line}.blank?
    pdu_line = self.pdu_lines.select{|l|l.name == line}.first
    pdu_line.pdu_outlet_groups << PduOutletGroup.create(name: group) if pdu_line.pdu_outlet_groups.select{|l|l.name == group}.blank?
  end

end
