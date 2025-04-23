# frozen_string_literal: true

RSpec.shared_context "with preferred columns" do |available_columns|
  context "with preferred columns in URL" do
    before do
      get url_for(columns: available_columns)
    end

    it "contains all available columns" do
      expect(response.body).to include(*available_columns)
    end
  end
end
