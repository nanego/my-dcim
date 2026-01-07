# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryDecorator, type: :decorator do
  let(:object) { Category.new(name: "some name", description: "some description", glpi_sync: :no) }
  let(:decorated_category) { described_class.decorate(object) }

  describe ".glpi_sync_human" do
    it do
      expect(decorated_category).to eq(Category.human_attribute_name(:no_glpi_sync))
    end
  end
end
