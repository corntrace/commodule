require File.dirname(__FILE__) + '/spec_helper'

describe Commodule do

  it "should load hack correctly" do
    Array.new.respond_to?(:find_dups).should == true
  end

  it "should load controller loader correctly" do
    Commodule::ControllerLoader.should_not be_nil
  end

  it "should load FeatureOrganizer correctly" do
    Commodule::FeatureOrganizer.should_not be_nil
  end

end
