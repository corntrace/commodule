require File.dirname(__FILE__) + '/spec_helper'
require 'rails_generator'
require 'rails_generator/scripts/generate'
require 'rails_generator/scripts/destroy'

describe "Commodule Migration Generator" do

  after :each do
    FileUtils.rm_r("#{RAILS_ROOT}/vendor/modules/shopping_order/db/migrate", :force => true)
  end

  it "should generate implemented migration file" do
    Rails::Generator::Scripts::Generate.new.run(["commodule_migration", "shopping_order", "add_qty_back_order_to_order_items", 'qty_back_order:integer', '-t'])
    #puts IO.read(Dir.glob("#{migration_root}/*").first)
    IO.read(Dir.glob("#{migration_root}/*").first).should match("add_column :order_items, :qty_back_order, :integer")
    Dir.glob("db/migrate/*.rb").sort.last.should match("add_qty_back_order_to_order_items")
    FileUtils.rm Dir.glob("db/migrate/*.rb").sort.last
  end

  it "should generate empty migration file" do
    Rails::Generator::Scripts::Generate.new.run(["commodule_migration", "shopping_order", "update_order_items_qty_back_order", '-t'])
    #puts IO.read(Dir.glob("#{migration_root}/*").first)
    IO.read(Dir.glob("#{migration_root}/*").first).should_not match("add_column :order_items, :qty_back_order, :integer")
    Dir.glob("db/migrate/*.rb").sort.last.should match("update_order_items_qty_back_order")
    FileUtils.rm Dir.glob("db/migrate/*.rb").sort.last
  end

  it "should delete the generated migration file" do
    Rails::Generator::Scripts::Generate.new.run(["commodule_migration", "shopping_order", "update_order_items_qty_back_order", '-t'])
    Rails::Generator::Scripts::Destroy.new.run(["commodule_migration", "shopping_order", "update_order_items_qty_back_order"])
    Dir.glob("#{migration_root}").select{|item| item =~ /update_order_items_qty_back_order/}.should be_empty
    db_migrates = Dir.glob("db/migrate/*.rb")
    db_migrates.sort[-1].should match("reversed_update_order_items_qty_back_order")
    db_migrates.sort[-2].should match("update_order_items_qty_back_order")
    db_migrates.sort[-2..-1].each{|file| FileUtils.rm file}
  end

  it "should show the usage message" do
    lambda do
      Rails::Generator::Scripts::Generate.new.run(["commodule_migration"])
    end.should raise_error
  end

  def migration_root
    "#{RAILS_ROOT}/vendor/modules/shopping_order/db/migrate"
  end
    
end
