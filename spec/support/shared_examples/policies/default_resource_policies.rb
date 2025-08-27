# frozen_string_literal: true

RSpec.shared_examples "with default index policy", type: :policy do
  it_behaves_like "act as index policy", for: :index?
end

RSpec.shared_examples "with default create policy", type: :policy do
  it_behaves_like "act as create policy", for: :create?
end

RSpec.shared_examples "with default manage policy", type: :policy do
  it_behaves_like "act as manage policy", for: :manage?
end
