# frozen_string_literal: true

json.array! @documents, partial: 'documents/document', as: :document
