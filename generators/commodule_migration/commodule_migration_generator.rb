require File.dirname(__FILE__)+'/../../lib/hack'

class CommoduleMigrationGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    @mod_name = runtime_args.shift 
    super
    raise "There's no module named with #@mod_name" unless modules_list.include?(@mod_name)
  end

  def manifest
    result = record do |m|
      m.migration_template('migration:migration.rb', "vendor/modules/#{@mod_name}/db/migrate", :assigns => commodule_local_assigns )
    end
  end

  protected
  def banner
    <<-EOS
Creates a migration file with the given for the given module.

USAGE: #{$0} #{spec.name} module_name migration_name [column:type] <recursive> [options]

EOS
  end

  private
  def commodule_local_assigns
    returning(assigns = {}) do
      if class_name.underscore =~ /^(add|remove)_.*_(?:to|from)_(.*)/
        assigns[:migration_action] = $1
        assigns[:table_name] = $2.pluralize
      else
        assigns[:attributes] = []
      end
    end
  end

  def modules_list
    Dir.glob("#{RAILS_ROOT}/vendor/modules/*").map {|dir| File.basename(dir)}
  end

  def migration_file_path
    Dir.glob("#{RAILS_ROOT}/vendor/modules/#{@mod_name}/db/migrate/*.rb").select do |file|
      filename =~ %r{#{file_name}}
    end.first
  end
  

end
