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
        # TODO FIRST: create a reversed migration file to db/migrate
        send_actions(target || @target, @actions.reverse)
      end
    end
  end
end
