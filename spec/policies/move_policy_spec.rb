# frozen_string_literal: true

require "rails_helper"

RSpec.describe MovePolicy, type: :policy do
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  it_behaves_like "act as manage policy", for: :index?
  it_behaves_like "act as manage policy", for: :execute?
  it_behaves_like "act as manage policy", for: :load_server?
  it_behaves_like "act as manage policy", for: :load_frame?
  it_behaves_like "act as manage policy", for: :load_connection?
  it_behaves_like "act as manage policy", for: :update_connection?
end
