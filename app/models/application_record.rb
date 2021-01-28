# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # KSUIDs
  include KSUID::ActiveRecord[:id]
  validates :id, length: 27..27
end
