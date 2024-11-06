class ChangelogEntriesController < ApplicationController
  def index
    @changelog_entries = sorted(changelog_scope.order(created_at: :desc))
    @pagy, @changelog_entries = pagy(@changelog_entries, items: 100)
  end

  def show
    @changelog_entry = decorate ChangelogEntry.find(params[:id])
  end

  private

  def scoped_object
    return unless params[:object_type] && params[:object_id]

    @scoped_object ||= begin
      klass = params[:object_type].camelize.singularize.safe_constantize

      if klass.respond_to?(:friendly)
        klass&.friendly&.find(params[:object_id])
      else
        klass&.find(params[:object_id])
      end
    end
  end

  def changelog_scope
    return ChangelogEntry.where(object: scoped_object) if scoped_object

    ChangelogEntry.all
  end

  def per_page
    @per_page ||= turbo_frame_request? ? 10 : 50
  end
end
