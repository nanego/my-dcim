# frozen_string_literal: true

RSpec.shared_context "with delete confirmation view" do |record:, route: nil|
  let(:confirm) { nil }
  let(:params)  { {} }

  context "with preferred columns in URL" do
    if route
      let(:response) do
        delete public_send(route, record, params.merge(confirm:))

        # NOTE: used to simplify usage and custom test done in final spec file.
        @response # rubocop:disable RSpec/InstanceVariable
      end
    else
      before do
        delete url_for(record, params.merge(confirm:))
      end
    end

    context "without confirmation" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:delete) }
      it { expect { response }.not_to change(record.klass, :count) }

      it do
        record.reload

        expect(record.destroyed?).to be(false)
      end

      context "with confirmation" do
        let(:confirm) { true }

        it { expect(response).to have_http_status(:redirection) }
        it { expect { response }.to change(record.klass, :count).by(-1) }
        it { expect {  record.reload }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end
end
