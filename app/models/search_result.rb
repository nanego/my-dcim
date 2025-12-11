# frozen_string_literal: true

class SearchResult < ApplicationRecord
  self.primary_key = %i[searchable_type searchable_id]

  belongs_to :searchable, polymorphic: true

  def self.search(query)
    return none if query.blank?

    where("term ILIKE :query", query: "%#{query.downcase}%")
      .includes(
        searchable: {
          modele: %i[manufacturer category],
          bay: { islet: { room: :site } },
        },
      ).order("lower(name) ASC")
  end

  def readonly?
    true
  end
end
