class UpdateForeignIds < ActiveRecord::Migration
  def up
    frames = Frame.all
    has_been_migrated = []
    frames.each do |frame|
      if has_been_migrated.exclude? frame
        islet = Islet.find_or_create_by(name: frame.ilot, room_id: frame.room_id)

        bay = Bay.new(islet: islet)
        bay.position = frame.title[-1].to_i
        if frame.other_frame_through_couple_baie.present?
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

        other_frame = frame.other_frame_through_couple_baie.first
        if other_frame.present?

          other_frame.bay_id = bay.id
          other_frame.save

          has_been_migrated << other_frame
        end

        has_been_migrated << frame
      end
    end
  end
end
