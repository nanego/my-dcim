# frozen_string_literal: true

require "rails_helper"

RSpec.describe PermissionScopeUserPolicy, type: :policy do
  # See https://actionpolicy.evilmartians.io/#/testing?id=rspec-dsl
  #
  # let(:user) { build_stubbed :user }
  # let(:record) { build_stubbed :post, draft: false }
  # let(:context) { {user: user} }

  describe_rule :index? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  describe_rule :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  describe_rule :manage? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
