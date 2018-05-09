class GLPIWrapper
  include Singleton

  class << self
    delegate :get_computer_by_name, to: :instance
  end

  def initialize
    @glpi_client = GLPIClient.new
  end

  def get_computer_by_name(name)
    computer_attributes = glpi_client.
        get_computer(n: name).
        deep_transform_keys(&:underscore)
    Computer.new(computer_attributes)
  end

  private

  attr_reader :glpi_client
end

class GLPIWrapper::Computer
  include Virtus.model

  attribute :name, String
  attribute :year, Integer
  attribute :runtime, Integer
end
