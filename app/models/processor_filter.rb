# frozen_string_literal: true

class ProcessorFilter < Filter
  def initialize(records, params, with: nil)
    @records = records
    @rubanok_class = with || guess_processor_from_records

    raise "Processor class missing" unless @rubanok_class

    super(params, @rubanok_class.fields_set.to_a)
  end

  def results
    @results ||= @rubanok_class.call(@records, attributes)
  end

  def total_count
    @total_count ||= @records.count
  end

  def results_count
    @results_count ||= results.count
  end

  private

  def guess_processor_from_records(records)
    return if records.blank?

    "#{records.klass&.to_s&.pluralize}Processor".safe_constantize
  end
end
