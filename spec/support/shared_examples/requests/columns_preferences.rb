# frozen_string_literal: true

RSpec.shared_context "with preferred columns" do |available_columns, route: nil|
  let(:columns) { available_columns }

  context "with preferred columns in URL" do
    if route
      let(:response) do
        get public_send(route, columns:)

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end
    else
      before do
        get url_for(columns:)
      end
    end

    it "renders all available columns" do
      columns.each do |column|
        expect(response.body).to have_tag("th", with: { "data-name": column })
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
          expect(response.body).to have_tag("th", with: { "data-name": column })
        end
      end

      it "does not render non-preferred columns" do
        expect(response.body).not_to have_tag("th", with: { "data-name": hidden_column })
      end
    end
  end
end
