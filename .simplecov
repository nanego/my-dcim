# frozen_string_literal: true

require "simplecov-console"

SimpleCov.configure do
  project_name "MyDCIM"

  # group "Channels", "app/channels"
  group "Components", "app/components"
  group "Decorators", "app/decorators"
  group "Exporters", "app/exporters"
  group "Policies", "app/policies"
  group "Processors", "app/processors"
  group "Services", "app/services"
  # group "Validators", "app/validators"
  group "Long files" do |src_file|
    src_file.lines.count > 500
  end

  # minimum_coverage 85
  # converage :line do
  #   minimum_per_file 50
  # end

  # formatter SimpleCov::Formatter::MultiFormatter.new([
  #                                                      SimpleCov::Formatter::HTMLFormatter,
  #                                                      SimpleCov::Formatter::Console
  #                                                    ])
end
