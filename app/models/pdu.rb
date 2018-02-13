class Pdu

  SIDES = {:right => "right", :left => "left"}

  def self.calculated_side(frame, name)
    if frame.bay.bay_type.size <= 1
      if name == 'A'
        SIDES[:left]
      else
        SIDES[:right]
      end
    else
      if frame.position.odd?
        SIDES[:left]
      else
        SIDES[:right]
      end
    end
  end

end
