# frozen_string_literal: true

class DeviseFailureApp < Devise::FailureApp
  def skip_format?
    %w[html */* turbo_stream pdf].include? request_format.to_s
  end
end
