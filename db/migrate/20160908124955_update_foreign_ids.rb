class UpdateForeignIds < ActiveRecord::Migration
  def up
    frames = Frame.all
    has_been_migrated = []
    frames.each do |frame|
      if has_been_migrated.exclude? frame
        islet = Islet.find_or_create_by(name: frame.ilot, room: frame.room)

        bay = Bay.new(islet: islet)
        bay.position = frame.title[-1].to_i
        # puts "001 : bay.position = #{bay.position}"
        if frame.has_coupled_frame?
          bay.bay_type_id = 2
        else
          bay.bay_type_id = 1
        end
        if bay.position.odd? # impair?
          bay.lane = 1
        else
          bay.lane = 2
        end
        bay.save

        frame.bay_id = bay.id
        frame.save

        if frame.has_coupled_frame?

          # puts "002 - #{frame.other_frame.inspect}"

          frame.other_frame.bay_id = bay.id
          frame.other_frame.save

          has_been_migrated << frame.other_frame
        end

        has_been_migrated << frame
      end
    end
  end
end
