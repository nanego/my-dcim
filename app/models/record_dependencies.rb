class RecordDependencies
  ALLOW_DEPEDENCY_OPTIONS = %i[
    restrict_with_error
    destroy
  ].freeze

  EXCLUDED_KLASSES = [ActiveStorage::Blob, ActiveStorage::Attachment].freeze

  Dependency = Data.new(:association, :origin) do
    delegate :name, :klass, to: :association

    def records
      origin.public_send(association.name)
    end

    def empty?
      records.blank?
    end
  end

  def initialize(record, only: [], except: [])
    @record = record
    @only = only
    @except = except

    @dependencies = {}
  end

  def destroyable
    dependencies[:destroy]
  end

  def restricted_with_error
    dependencies[:restrict_with_error]
  end

  # def nillable
  # end

  def dependencies
    @dependencies ||= _load_dependencies
  end

  private

  def _load_dependencies
    @record.class.reflect_on_all_associations.each do |association|
      # exclude according to config
      next unless association_counts?(association)

      dependency = Dependency.new(association, @record)

      next if records.empty?

      (@dependencies[association.options[:dependent]] ||= []) << dependency
    end
  end

  # TODO: rename
  def association_counts?(association)
    # only is above default config
    return @only.include?(association.name) unless @only.nil?

    # default behavior
    return false unless ALLOW_DEPEDENCY_OPTIONS.include?(association.options[:dependent])
    return false if %i[changelog_entries slugs].include?(association.name)
    return false if EXCLUDED_KLASSES.include?(association.klass)

    # exept is not above default config
    @expect.nil? || @expect.exclude?(association.name)
  end
end
