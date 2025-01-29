# frozen_string_literal: true

module List
  class TableComponent < ApplicationComponent
    erb_template <<~ERB
      <div class="table-responsive">
        <%= tag.table(**@html_attributes) do %>
          <% heads.each do |thead| %>
            <%= thead %>
          <% end %>
          <% bodies.each do |tbody| %>
            <%= tbody %>
          <% end %>
          <% foots.each do |tfoot| %>
            <%= tfoot %>
          <% end %>
        <% end %>
      </div>
    ERB

    renders_many :heads,  "TableHead"
    renders_many :bodies, "TableBody"
    renders_many :foots,  "TableFoot"

    def initialize(**html_attributes)
      super()

      css_classes = html_attributes.delete(:class)

      @html_attributes = html_attributes.merge(
        class: class_names("table table-striped table-bordered table-hover mb-0", css_classes),
      )
    end

    class TableTag < ApplicationComponent
      TAG_NAME = nil.freeze
      CSS_CLASSES = "".freeze

      def initialize(**html_attributes)
        super()

        css_classes = html_attributes.delete(:class)

        @html_attributes = html_attributes.merge(
          class: class_names(self.class::CSS_CLASSES, css_classes),
        )
      end

      def call
        content_tag(self.class::TAG_NAME, content, **@html_attributes)
      end
    end

    class TableHead < TableTag
      TAG_NAME = :thead.freeze
      CSS_CLASSES = "".freeze
    end

    class TableBody < TableTag
      TAG_NAME = :tbody.freeze
      CSS_CLASSES = "".freeze
    end

    class TableFoot < TableTag
      TAG_NAME = :tfoot.freeze
    end

    class TableRow < TableTag
      TAG_NAME = :tr.freeze
      CSS_CLASSES = "".freeze # FIXME: should be applied only on body
    end

    class TableCell < TableTag
      TAG_NAME = :td.freeze
      VERTICAL_ALIGN_TYPES = {
        baseline: "align-baseline",
        top: "align-top",
        middle: "align-middle",
        bottom: "align-bottom",
        text_top: "align-text-top",
        text_bottom: "align-text-bottom"
      }.freeze
      TEXT_ALIGN_TYPES = {
        left: "text-start",
        center: "text-center",
        right: "text-end"
      }.freeze

      def initialize(text = nil, **html_attributes)
        super(**html_attributes)

        @text = text

        css_classes = html_attributes.delete(:class)
        css_vertical_align = VERTICAL_ALIGN_TYPES[html_attributes.delete(:v_align)&.to_sym || :middle]
        css_text_align = TEXT_ALIGN_TYPES[html_attributes.delete(:text_align)&.to_sym || :left]

        @html_attributes = html_attributes.merge(
          class: class_names(
            css_vertical_align,
            css_text_align,
            css_classes,
            "": (@text.present? && css_classes.nil?),
          ),
        )
      end

      private

      def content
        @text || super
      end
    end

    class TableHeadCell < TableCell
      TAG_NAME = :th.freeze
      CSS_CLASSES = "".freeze
    end
  end
end
