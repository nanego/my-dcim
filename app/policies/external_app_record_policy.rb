# frozen_string_literal: true

class ExternalAppRecordPolicy < ApplicationPolicy
  def index?
    manage?
  end

  def settings?
    index?
  end

  def sync_all_servers_with_glpi?
    manage?
  end
end
