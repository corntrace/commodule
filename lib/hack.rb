class Array
  def find_dups
    uniq.map {|v| (self - [v]).size < (self.size - 1) ? v : nil}.compact
  end
end

ActionController::Routing::Routes.instance_eval(%Q{
  def clear!
  end
}) if defined? ActionController

module Rails
  module Generator
    class Manifest
      # Replay recorded actions.
      def replay(target = nil)
        send_actions(target || @target, @actions)
        puts "Copying generated migration file to db/migrate"
        FileUtils.cp Dir.glob("#{RAILS_ROOT}/#{@actions.first.second.second}/*.rb").sort.last, FileUtils.mkdir_p("#{RAILS_ROOT}/db/migrate")
      end

      # Rewind recorded actions.
      def rewind(target = nil)
        # creating a reversed migration file to db/migrate
        puts "Generating reversed migration file in db/migrate"
        source_file_name = Dir.glob("#{RAILS_ROOT}/#{@actions.first.second.second}/*.rb").sort.last
        target_file_name = FileUtils.mkdir_p("#{RAILS_ROOT}/db/migrate/")+\
          File.basename(source_file_name).gsub(/^(\d*)/, "#{1.second.since(Time.now.utc).strftime("%Y%m%d%H%M%S")}_reversed")
        FileUtils.cp source_file_name, target_file_name 
        # TODO reversed the target migration file's content 
        send_actions(target || @target, @actions.reverse)
      end
    end
  end
end

module ActionMailer
  class Base
    adv_attr_accessor :custom_template_root
    def template_path
      "#{custom_template_root || template_root}/#{mailer_name}"
    end
    def template_root
      if custom_template_root
        self.view_paths = ActionView::Base.process_view_paths(custom_template_root)
      else
        self.class.template_root
      end
    end
  end
end
