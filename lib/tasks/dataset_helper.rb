
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
      # reset sequences
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end 
    end # transaction 
  end
end # class