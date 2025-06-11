# frozen_string_literal: true

RSpec.shared_examples "with create another one" do
  before do
    params[:create_another_one] = true
  end

  it { expect(response).to redirect_to(url_for(action: :new, create_another_one: "1")) }
end
