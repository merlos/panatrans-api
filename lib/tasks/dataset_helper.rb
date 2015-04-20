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

class DatasetHelper  
  
  def self.default_csv_dir
    Rails.root.join('tmp', 'dataset')
  end
  
  # 
  # List of model classes that can be imported
  def self.importable_models
    [Route, Stop, Trip, StopSequence]
    # Note it would be cooler to use ActiveRecord::Base.descendants 
    # but Trip has to be imported before StopSequences (descendants comes in alphabetical order)
  end
  
  # Downloads dataset CSV files from a GIT repository 
  #
  # options:
  #    git_url  url of the git repository 
  #    branch   branch of the git repository
  #    csv_dir  path to csv (will be cleaned)
  def self.download(opts = {})
    
    @git_url = opts[:git_url] || 'https://github.com/merlos/panatrans-dataset.git'
    @clone_opts = {}
    @clone_opts[:branch] = opts[:branch] || 'master'
    @clone_opts[:path] = opts[:csv_dir] || self.default_csv_dir.to_s
    @clone_opts[:depth] = 1
    
    puts "          git repository: " + @git_url.to_s
    puts "                  branch: " + @clone_opts[:branch]
    puts "                 CSV dir: " + @clone_opts[:path]
    puts "                  exists: " + File.directory?(@clone_opts[:path]).to_s
    #puts @clone_opts
    
    # check if dest_folder exists, if not try to create it
    FileUtils.remove_dir(@clone_opts[:path]) if (File.directory?(@clone_opts[:path]))
    FileUtils.mkdir_p(@clone_opts[:path]) unless File.directory?(@clone_opts[:path])
    git = Git.clone(@git_url, '', @clone_opts)
  end
  
  def self.import(csv_dir = '')
    csv_dir = self.default_csv_dir.to_s if csv_dir === ''
    puts "   Importing data from: " + csv_dir
    Rails.application.eager_load! 
    ActiveRecord::Base.transaction do
      self.importable_models.each do |model|
        #only import if method csv_import is defined on the model
        filepath = csv_dir + '/' + model.to_s.tableize  + ".csv"
        model.csv_import(filepath) if (model.respond_to? :csv_import) && (File.readable? (filepath))
      end      
      # Patch for heroku + postgres db. 
      # reset sequences if responds to reset_pk_sequence! 
      if ActiveRecord::Base.connection.respond_to? (:reset_pk_sequence!) 
        ActiveRecord::Base.connection.tables.each do |t|
          ActiveRecord::Base.connection.reset_pk_sequence!(t) 
        end 
      end
    end # transaction 
  end
end # class