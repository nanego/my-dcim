# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesProcessor do
  subject(:result) { described_class.call(input, params) }

  let(:input) { Category.all }
  let(:params) { {} }

  describe "when sorting" do
    pending "TODO"
  end
end
