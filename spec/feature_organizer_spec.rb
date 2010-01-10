require File.dirname(__FILE__) + '/spec_helper'

describe Commodule::FeatureOrganizer do

  before :each do
    # make a fake rails_root
    FileUtils.mkdir_p(fake_rails_root)
    create_fake_features("test_module")
    @org = Commodule::FeatureOrganizer.new("test_module", fake_rails_root) 
  end

  after :each do
    @org.release
    # delete the fake rails_root
    FileUtils.rm_r(fake_rails_root)
  end

  it "fake rails root should be exists" do
    File.exists?(fake_rails_root).should == true
  end

  it "fake features should be exists" do
    features = Dir.glob("#{fake_rails_root}/features/*.feature").sort
    IO.read(features.first).should match("Feature: Test Feature 1")
  end

  it "fake module features should be exists" do
    features = Dir.glob("#{fake_rails_root}/vendor/modules/test_module/features/*.feature").sort
    IO.read(features.first).should match("Feature: Test Module Feature 1")
  end

  it "should combine main features and module features into one temp file" do
    combined_file = @org.combine
    File.exists?(combined_file.path).should be_true
    IO.read(combined_file.path).should match("Feature: Test Feature 1")
    IO.read(combined_file.path).scan(/Feature: Test Module Feature 2/).size.should == 1
  end

  it "should replace the scenario by the one defined in module features" do
    @org.combine; @org.scan_and_replace
    IO.read(@org.tmpfile.path).scan("Scenario: test scenario 1-2").size.should == 1
  end

  it "should raise error when split feature file but it's not ready" do
    lambda {@org.split}.should raise_error
  end

  it "should split the features file into 4 seperated files" do
    @org.combine; @org.split
    feature_files = Dir.glob("#{@org.tmpdir}/*.feature").sort
    IO.read(feature_files.first).scan("Feature: Test Feature 1").size.should == 1
    IO.read(feature_files.first).scan("Feature: Test Feature 2").size.should == 0
    IO.read(feature_files.last).scan("Feature: Test Module Feature 2").size.should == 1
  end

  def create_fake_features(mod_name)# {{{
    dir = FileUtils.mkdir_p(fake_rails_root+'/features')
    [1,2].each do |i|
      File.open("#{dir}/feature#{i}.feature", 'w') do |f|
        f.write <<-EOF
          Feature: Test Feature #{i}
            Scenario: test scenario #{i}-1
              Given some params ready
              When I do something
              Then I should get some result
            Scenario: test scenario #{i}-2
              Given some params ready
              When I do something
              Then I should get some result
          EOF
      end
    end

    dir = FileUtils.mkdir_p(fake_rails_root+"/vendor/modules/#{mod_name}/features")
    [1,2].each do |i|
      File.open("#{dir}/feature#{i}.feature", 'w') do |f|
        f.write <<-EOF
          Feature: Test Module Feature #{i}
            Scenario: test module scenario #{i}-1
              Given some params ready
              When I do something
              Then I should get some result
            Scenario: test module scenario #{i}-2
              Given some params ready
              When I do something
              Then I should get some result

            Scenario: test scenario #{i}-2
              Given some params ready
              When I do something
              Then I should get some result
          EOF
      end
    end

  end# }}}

end
