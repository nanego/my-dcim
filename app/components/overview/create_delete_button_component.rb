# frozen_string_literal: true

module Overview
  class CreateDeleteButtonComponent < ApplicationComponent
    def initialize(bay_id, position, **html_options)
      @bay_id = bay_id
      @position = position
      @html_options = html_options

      super
    end

    def call
      tag.span(class: "create-delete-button-component") do
        concat(
          link_to bay_path(@bay_id),
                  method: :delete,
                  class: "link-danger",
                  title: t(".delete_button.title"),
                  aria: { hidden: true },
                  data: {
                    confirm: t(".delete_button.confirm"),
                    controller: "tooltip",
                    bs_placement: "bottom"
                  } do
            tag.span(class: "bi bi-dash-circle-fill")
          end
        )
        concat(
          link_to new_frame_path(frame: { bay_id: @bay_id, position: @position }),
                  class: "link-success",
                  title: t(".create_button.title"),
                  aria: { hidden: true },
                  data: {
                    controller: "tooltip",
                    bs_placement: "bottom"
                  } do
            tag.span(class: "bi bi-plus-circle-fill")
          end
        )
      end
    end
  end
end


# <div class="overflow-x-auto pb-2">
#   <div class="d-inline-grid row-gap-2">
#     <% bays_per_lane.each do |lane, bays| %>
#       <span class="d-flex column-gap-2" style="grid-row:<%= "#{lane.to_i}/#{lane.to_i+1}" %>;">
#         <% bays.each.with_index(1) do |bay, i| %>
#           <% if bay == :no_bay %>
#             <span class="d-flex col" style="max-width: fit-content; grid-column: <%= "#{i}/#{i+1}" %>;">
#               <span class="bay">
#                 <span class="bi bi-plus-circle-fill"></span>
#               </span>
#             </span>
#           <% else %>
#             <span class="d-flex col" style="max-width: fit-content; grid-column: <%= "#{i}/#{i+1}" %>;">
#               <% frames_array = bay.frames.sorted.to_a %>
#               <% (bay.bay_type.to_s == "single" ? 1 : 2).times do |j| %>
#                 <% frame = frames_array[j] %>
#                 <% if frame %>
#                   <% should_be_highlighted = @frames && @frames.include?(frame) %>
#                   <span class="<%= class_names(
#                                       "bay d-flex bg-secondary-subtle border-secondary-subtle border py-2 align-items-center",
#                                       "border-start-0": j.odd?,
#                                       highlighted: should_be_highlighted) %>">
#                     <%= link_to frame.name,
#                                 visualization_room_path(
#                                   frame.room,
#                                   view: params[:view],
#                                   islet: islet,
#                                   "bay-id": bay,
#                                   "frame-id": frame
#                                 ),
#                                 class: class_names(
#                                   "link-body-emphasis mx-auto text-center px-1",
#                                   "text-info-emphasis": should_be_highlighted
#                                 )
#                     %>
#                   </span>
#                 <% else %>
#                   <span class="bay d-flex bg-body-tertiary border-secondary-subtle border">
#                     <%= render Overview::CreateDeleteButtonComponent.new(
#                       bay.id, i, class: class_names("border-start-0": j.odd?)
#                     ) %>
#                   </span>
#                 <% end %>
#               <% end %>
#             </span>
#           <% end %>
#         <% end %>
#       </span>
#     <% end %>
#   </div>
# </div>
