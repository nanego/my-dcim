# frozen_string_literal: true

class RecordDependencies
  ALLOW_DEPEDENCY_OPTIONS = %i[restrict_with_error destroy].freeze
  EXCLUDED_KLASSES = [ActiveStorage::Blob, ActiveStorage::Attachment].freeze

  Dependency = Data.define(:association, :origin) do
    delegate :name, to: :association

    def title
      association.klass.model_name.human
    end

    def records
      origin.public_send(association.name)
    end

    def type
      association.options[:dependent]
    end

    def empty?
      records.blank?
    end
  end

  def initialize(record, only: nil, except: nil)
    @record = record
    @only = Array(only).map(&:to_sym) if only.present?
    @except = Array(except).map(&:to_sym) if except.present?
  end

  def grouped_by_dependent
    [
      [:restrict, restricted_with_error],
      [:destroy, destroyable],
    ]
  end

  def destroyable
    dependencies_per_type[:destroy] || []
  end

  def restricted_with_error
    dependencies_per_type[:restrict_with_error] || []
  end

  def dependencies_per_type
    _load_dependencies if @dependencies_per_type.nil?
    @dependencies_per_type
  end

  private

  def _load_dependencies
    @dependencies_per_type = {}
    @record.class.reflect_on_all_associations.each do |association|
      # exclude according to config

      next unless association_valid?(association)

      dependency = Dependency.new(association, @record)
      next if dependency.empty?

      # add dependency according to his type
      (@dependencies_per_type[association.options[:dependent]] ||= []) << dependency
    end
  end

  def association_valid?(association)
    # only is above default config
    return @only.include?(association.name) unless @only.nil?

    # default behavior
    return false unless ALLOW_DEPEDENCY_OPTIONS.include?(association.options[:dependent])
    return false if %i[changelog_entries slugs].include?(association.name)
    return false if EXCLUDED_KLASSES.include?(association.klass)

    # exept is not above default config
    @except.nil? || @except.exclude?(association.name)
  end
end
