# frozen_string_literal: true

module RailsIam
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
