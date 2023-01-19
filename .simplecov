require "simplecov-console"

SimpleCov.start :rails do
  project_name "<%= application_name %>"

  # add_group "Admin", "app/admin"
  # add_group "Channels", "app/channels"
  # add_group "Components", "app/components"
  # add_group "Decorators", "app/decorators"
  # add_group "Policies", "app/policies"
  add_group "Services", "app/services"
  # add_group "Validators", "app/validators"
  add_group "Long files" do |src_file|
    src_file.lines.count > 500
  end

  minimum_coverage 50
  minimum_coverage_by_file 50

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
  ])
end
