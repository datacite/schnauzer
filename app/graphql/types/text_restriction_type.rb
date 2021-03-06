# frozen_string_literal: true

class TextRestrictionType < BaseObject
  description "Information"
  
  field :text, String, null: false, description: "Information"
  field :restriction, [String], null: true, description: "Restriction"
end
