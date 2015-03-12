require_relative './dataset_helper'

namespace :dataset do
  desc "downloads dataset from git (TODO options: DATASET_GIT_URL=github.com/merlos/panatrans-dataset, DATASET_DIR=./tmp/dataset, DATASET_GIT_BRANCH=master]"
  task download: :environment do
    DatasetHelper.download
  end

  desc "imports dataset csv files into database (db not cleared) (TODO options: DATASET_DIR=./tmp/dataset/)"
  task import: :environment do
    DatasetHelper.import #it is performed under a transaction, or imports everything or nothing
  end

  desc "clears the database and then imports last downloaded csv files"
  task reset: :environment do
      Rake::Task["db:reset"].invoke # db:reset == db:drop + db:setup
      Rake::Task["dataset:import"].invoke 
  end

  desc "updates dataset. First downloads it then resets it. Equivalent to dataset:download + dataset:reset"
  task update: :environment do
    Rake::Task["dataset:download"].invoke
    Rake::Task["dataset:reset"].invoke
  end

  desc "Loads development fixtures in current environment database (clears database)"
  task fixtures: :environment do
    Rake::Task["db:fixtures:load"].invoke
  end

end
