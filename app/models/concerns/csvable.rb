module Csvable
  extend ActiveSupport::Concern

  require 'csv'

  module ClassMethods

    def as_csv
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end
  end
end
  