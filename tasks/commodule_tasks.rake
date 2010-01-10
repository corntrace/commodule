namespace :commodule do
  desc "list all modules"
  task :list do
    puts Dir["#{RAILS_ROOT}/vendor/modules/*"]\
      .collect{|dir| File.basename(dir)}.sort.join(10.chr)
  end
end

# Load any rakefile extensions in vendor/modules
Dir["#{RAILS_ROOT}/vendor/modules/*/lib/tasks/*.rake"].sort.each { |ext| load ext }
