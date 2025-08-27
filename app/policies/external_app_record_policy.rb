# frozen_string_literal: true

class ExternalAppRecordPolicy < ApplicationPolicy
  pre_check :deny_readers

  def settings?
    manage?
  end

  def sync_all_servers_with_glpi?
    manage?
  end
end
