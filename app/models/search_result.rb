# frozen_string_literal: true

class SearchResult < ApplicationRecord
  belongs_to :searchable, polymorphic: true

  def self.search(query)
    return none if query.blank?

    where("term ILIKE :query", query: "%#{query}%")
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
