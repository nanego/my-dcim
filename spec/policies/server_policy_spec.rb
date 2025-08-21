# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServerPolicy, type: :policy do
  it_behaves_like "with default index policy"
  it_behaves_like "with default create policy"
  it_behaves_like "with default manage policy"

  it_behaves_like "act as manage policy", for: :sort?
  it_behaves_like "act as manage policy", for: :import?
  it_behaves_like "act as manage policy", for: :import_csv?
  it_behaves_like "act as manage policy", for: :duplicate?
  it_behaves_like "act as index policy", for: :export?
end
