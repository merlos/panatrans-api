# The MIT License (MIT)
# 
# Copyright (c) 2015 Juan M. Merlos, panatrans.org
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

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
  