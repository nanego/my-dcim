# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/bulk/stacks" do
  before { sign_in users(:one) }

  describe "DELETE /destroy" do
    context "with stacks without associations" do
      it do
        expect do
          delete bulk_stacks_path(ids: [stacks(:orange).id, stacks(:blue).id])
        end.to change(Stack, :count).by(-2)
      end

      it do
        delete bulk_stacks_path(ids: [stacks(:orange).id, stacks(:blue).id])
        expect(response).to redirect_to(stacks_path)
      end
    end

    context "with a stack with associations" do
      it do
        expect do
          delete bulk_stacks_path(ids: [stacks(:red).id])
        end.not_to change(Stack, :count)
      end

      it do
        delete bulk_stacks_path(ids: [stacks(:red).id])
        expect(response).to redirect_to(stacks_path)
      end
    end
  end
end
