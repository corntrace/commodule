module Commodule
  class ModuleLoader

    def self.load_modules()
      Dir.glob("#{RAILS_ROOT}/vendor/modules/*").each do |dir| 
        # TODO add loading priority feature
        self.new(File.basename(dir)).load_target
      end
    end

    def initialize(mod_name)
      @mod_name = mod_name
    end

    def load_target
      load_libs
      load_models
      load_helpers  # helpers should be loaded before controllers
      load_controllers
      load_routes
    end

    def load_libs
      path = "#{mod_root}/lib"
      $LOAD_PATH << path
      ActiveSupport::Dependencies.load_paths << path
      ActiveSupport::Dependencies.load_once_paths.delete(path)
    end

    def load_models
      Dir.glob("#{mod_root}/app/models/*.rb").each do |model|
        load model
      end
    end

    def load_helpers
      path = "#{mod_root}/app/helpers"
      $LOAD_PATH << path
      ActiveSupport::Dependencies.load_paths << path
      ActiveSupport::Dependencies.load_once_paths.delete(path)
    end
    
    def load_controllers
      Dir.glob("#{mod_root}/app/controllers/*.rb").each do |controller|
        load controller
      end
    end
    
    def load_routes
      require "#{mod_root}/config/routes.rb" if File.exists?("#{mod_root}/config/routes.rb")
    end

    private
    def mod_root
      File.expand_path "#{RAILS_ROOT}/vendor/modules/#{@mod_name}"
    end
    
  end
end
