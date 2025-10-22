# frozen_string_literal: true

RSpec.shared_context "with preferred columns" do |available_columns, route: nil|
  let(:columns) { available_columns }

  context "with preferred columns in URL" do
    before do
      get(route.nil? ? url_for(columns:) : public_send(route, columns:))
    end

    it "renders all available columns" do
      columns.each do |column|
        expect(response.body).to have_tag("th[data-name='#{column}']")
      end
    end

    context "when hiding columns" do
      let(:hidden_column) { available_columns.sample }
      let(:columns) do
        available_columns.dup.tap do |arr|
          arr.delete(hidden_column)
        end
      end

      it "renders preferred columns" do
        columns.each do |column|
          expect(response.body).to have_tag("th[data-name='#{column}']")
        end
      end

      it "does not render non-preferred columns" do
        expect(response.body).not_to have_tag("th[data-name='#{hidden_column}']")
      end
    end
  end
end
