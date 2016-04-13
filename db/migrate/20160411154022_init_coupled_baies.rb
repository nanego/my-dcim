class InitCoupledBaies < ActiveRecord::Migration
  def up

    previous_baie = nil
    Baie.order(:salle_id, :ilot, :position).each do |baie|

      if previous_baie.present? &&
          previous_baie.has_no_coupled_baie? &&
          previous_baie.salle == baie.salle &&
          previous_baie.ilot == baie.ilot

        CoupleBaie.create!(baie_one: previous_baie, baie_two: baie)

      end

      previous_baie = baie
    end

  end

  def down
    CoupleBaie.delete_all
  end
end
