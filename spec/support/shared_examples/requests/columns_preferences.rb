# frozen_string_literal: true

RSpec.shared_context "with preferred columns" do |available_columns|
  let(:columns) { available_columns }

  context "with preferred columns in URL" do
    before do
      get url_for(columns:)
    end

    it "renders all available columns" do
      columns.each do |column|
        expect(response.body).to have_tag("th[name='#{column}']")
      end
    end

    context "when hiding columns" do
      let(:columns) do
        available_columns.dup.tap do |arr|
          arr.delete_at(rand(arr.size))
        end
      end

      it "renders preferred columns" do
        columns.each do |column|
          expect(response.body).to have_tag("th[name='#{column}']")
        end
      end

      it "does not render non-preferred columns" do
        (available_columns - columns).each do |column|
          expect(response.body).not_to have_tag("th[name='#{column}']")
        end
      end
    end
  end
end
