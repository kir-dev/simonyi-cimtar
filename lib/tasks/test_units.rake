if !ENV["withoutspork"]

  Rake::Task["test:units"].clear
  
  namespace :test do

    desc "run unit tests"
    task :units do
      files = []
      Dir.glob(File.dirname(__FILE__) + "/../../test/unit/*_test.rb").each do |f|
        files << File.expand_path(f)
      end

      exec "testdrb -Itest #{files.join(' ')}"
    end
  end
end