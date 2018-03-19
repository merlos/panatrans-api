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

  #
  # List of model classes that will be dumped in json files
  def self.dumpable_models
    [GtfsApi::Route, GtfsApi::Stop] #GtfsApi Models
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

  #
  # Dump current server data into static json files, by default outputs in ./tmp/v1
  #
  # options:
  #    output_dir  path to directory where json files will be extracted
  def self.dump_json(opts = {})

    @output_dir = opts[:output_dir] || './tmp'
    @api_version = opts[:api_version] || 'v1'

    # Check output directories exist
    @output_path = Rails.root.join(@output_dir.chomp("/") + "/#{@api_version}")
    puts "  JSON files will be dumped at #{@output_path}"
    puts "  Removing directory #{@output_path} if exists"
    #FileUtils.remove_dir(@output_path) if (File.directory?(@output_path))
    puts "  Creating #{@output_path}"
    FileUtils.mkdir_p(@output_path) unless File.directory?(@output_path)
    @rails_session ||= ActionDispatch::Integration::Session.new(Rails.application)
    self.dumpable_models.each do |model|
      puts "  -- Dumping #{model.to_s}"
      # model.to_s returns "GtfsApi::Model",
      # tableize returns "gtfs_api/models"
      # the [] is a regex to keep only "models"
      model_name = model.to_s.tableize[/\/([a-zA-Z\_]*)\z/]

      # Dump ModelController.index
      url = "/#{@api_version}#{model_name}" # Ex: /v1/routes
      index_path = @output_path.to_s + model_name   # Ex: ./tmp/v1/routes (is a file)
      params = {}
      @rails_session.get(url, { :format => :json }.merge(params))
      puts "     Dumping #{model.to_s} from #{url} to #{index_path}"
      if (@rails_session.response.status == 200)
        File.open(index_path + ".json", "w") { |file | file.write @rails_session.response.body}
        puts "     ok"
      else
        puts "#{@rails_session.response.status} #{@rails_session.response.message}"
      end
      # Dumps each ModelController.show(id)
      items_folder = index_path + "/"  # Ex ./tmp/v1/routes/ (is a dir)
      puts "     -- Dumping details "
      puts "        Creating model directory #{items_folder}"
      FileUtils.mkdir_p(items_folder) unless File.directory?(items_folder)
      all = model.all
      all.each do |item|
        item_url = "#{url}/#{item.id}"
        item_file = items_folder  + item.id.to_s
        @rails_session.get(item_url, { :format => :json }.merge(params))
        puts "      Exporting #{model_name} from #{item_url} to (#{item_file})"
        #puts @rails_session.response.body
        if (@rails_session.response.status == 200)
          File.open(item_file, "w") { |file| file.write @rails_session.response.body}
          puts "      ok"
        else
          puts "#{@rails_session.response.status} #{@rails_session.response.message}"
        end
      end
    end
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
