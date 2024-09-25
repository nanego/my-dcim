# frozen_string_literal: true

class ApplicationProcessor < Rubanok::Processor
  def self.non_empty_array(val)
    non_blank = val.compact_blank

    return if non_blank.empty?

    non_blank
  end
end
