# frozen_string_literal: true

json.array! @contract_types, partial: 'contract_types/contract_type', as: :contract_type
