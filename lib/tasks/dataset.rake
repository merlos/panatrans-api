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
