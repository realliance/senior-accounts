# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # ULIDs
  include ULID::Rails
  ulid :id, primary_key: true
end
