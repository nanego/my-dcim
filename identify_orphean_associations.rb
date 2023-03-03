# frozen_string_literal: true

Rails.application.eager_load!

models_and_associations = ApplicationRecord.descendants.map do |m|
    m.reflections.values
end.flatten.select do |r|
    r.is_a? ActiveRecord::Reflection::BelongsToReflection
end.group_by(&:active_record)

orpheans = {}

models_and_associations.each do |model, associations|
  model.find_each do |record|

    associations.each do |association|
      next if association.polymorphic?

      id = record.public_send(association.foreign_key)

      next if id.nil?
      next if association.klass.find_by(id: id).present?

      orpheans[model] ||= {}
      orpheans[model][record] ||= {}
      orpheans[model][record][association] = id
    end
  end

  print "."
end

puts
puts
puts

puts "- Orphean records -"
puts

orpheans.each do |model, records|
  puts "--- #{model.name} ---"

  records.each do |record, associations|
    print "#{model.name}\##{record.id} - associations missing on "

    a = associations.map do |association, id|
      "#{association.name}=#{id}"
    end

    print a&.join(", ")

    print "\n"
  end

  puts
end
