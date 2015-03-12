module Csvable
  extend ActiveSupport::Concern

  require 'csv'

  module ClassMethods

    def as_csv
      # based on http://railscasts.com/episodes/362-exporting-csv-and-excel
      CSV.generate do |csv|
        csv << column_names
        all.each do |product|
          csv << product.attributes.values_at(*column_names)
        end
      end
    end
    
    def csv_import(filepath) 
      CSV.foreach(filepath, headers: true) do |row|
        row = row.to_hash
        record = find_by_id(row['id']) || new
        record.attributes = row.slice(*column_names)
        puts record.inspect
        record.save!
      end
    end
    
 #   def csv_import(filepath)
      # based on http://railscasts.com/episodes/396-importing-csv-and-excel
#      spreadsheet = CSV.new(filepath)
#      header = spreadsheet.row(1)
 #     (2..spreadsheet.last_row).each do |i|
#        row = Hash[[header, spreadsheet.row(i)].transpose]
#        product = find_by_id(row["id"]) || new
#        product.attributes = row.to_hash.slice(*accessible_attributes)
#        product.save!
#      end
#    end
  end
end
  