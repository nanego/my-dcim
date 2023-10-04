module ChangelogContextApplication
  extend ActiveSupport::Concern

  included do
    before_action do
      ChangelogContext.author = current_user
      ChangelogContext.metadata = {
        request_id: request.uuid,
      }
    end
  end
end
