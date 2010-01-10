require 'tempfile'

module Commodule
  class FeatureOrganizer

    attr_reader :tmpdir, :tf
    alias_method :tmpfile, :tf

    def initialize(mod_name, rails_root=RAILS_ROOT)
      @tmpdir = Dir.mktmpdir
      @main_features = Dir.glob("#{rails_root}/features/*.feature")
      @module_features = Dir.glob("#{rails_root}/vendor/modules/#{mod_name}/features/*.feature")
      raise "You should add cucumber features first." if @main_features.empty?
    end

    def combine
      return @tf unless @tf.nil?
      @tf = Tempfile.new("combined_feature", @tmpdir)
      # the main features come first and the modules features follow them
      @main_features.concat(@module_features).each do |feature|
        @tf.write(IO.read(feature))
      end
      @tf.close()
      return @tf
    end

    def scan_and_replace
      matching = %x{ cat #{@tf.path} | grep -n -e "Scenario:" -e "Feature:" | awk -F":" '{print $1"~##~"$2":"$3}' }
      line_numbers, titles = [], []
      matching.split(/\n/).each do |line| 
        a = line.split(/~##~\s*/)
        line_numbers << a.first
        titles << a.last
      end
      titles.find_dups.collect{|item| titles.index(item)}.each do |no|
        start_line_no = line_numbers[no]
        end_line_no = line_numbers[no+1].to_i-1 || '$'
        %x{cat #{@tf.path} | sed '#{start_line_no},#{end_line_no} d' > #{@tf.path}}
      end
    end

    def split
      raise "The temp file is not prepared." if @tf.nil?
      features = IO.read(@tf.path).scan(/Feature:.*/)
      features.each_index do |i|
        empty_feature_file_path = create_temp_feature_file i
        # substract temp_feature_file
        File.open(empty_feature_file_path, 'w'){|file| file.write(substruct_feature(features[i], features[i+1]))}
      end
    end

    def release
      system("rm -rf #{@tmpdir}")
    end

    private 
    def create_temp_feature_file(refactor)
      rst = FileUtils.touch("#{@tmpdir}/#{Time.now.to_i}_#{refactor}.feature")
      raise "Creating temp feature file failed." if rst.empty?
      return rst.first
    end

    def substruct_feature(from_line, to_line)
      start_line_no = get_line_number(from_line).to_i 
      end_line_no = to_line ? get_line_number(to_line).to_i-1 : '$' 
      %x{ cat #{@tf.path} | sed -n '#{start_line_no},#{end_line_no}p'}
    end

    def get_line_number(match_str)
      %x{ cat #{@tf.path} | grep -n "#{match_str}" | awk -F":" '{print $1}'}
    end
    
  end
end
