class ChangelogEntriesController < ApplicationController
  def index
    @changelog_entries = ChangelogEntry.order(created_at: :desc).limit(100)
  end

  def show
    @changelog_entry = ChangelogEntry.find(params[:id])
  end
end
