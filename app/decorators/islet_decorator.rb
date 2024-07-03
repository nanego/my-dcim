# frozen_string_literal: true

class IsletDecorator < ApplicationDecorator
  class << self
    def grouped_by_sites_options_for_select
      Islet.includes(:site, room: :islets).sorted.not_empty.has_name.distinct.group_by(&:site).to_h do |site, islets|
        islets = islets.map do |i|
          name = i.room.islets.size > 1 ? "#{i.room.name} #{i.name}" : i.room.name
          [name, i.id]
        end

        [site.name, islets]
      end
    end
  end
end
