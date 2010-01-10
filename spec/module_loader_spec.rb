require File.dirname(__FILE__) + '/spec_helper'
require 'spec/rails/example/routing_helpers'
include Spec::Rails::Example::RoutingHelpers

describe Commodule::ModuleLoader do

  MOD_NAME = "shopping_order"

  before :all do
    Commodule::ModuleLoader.load_modules
  end

  after :each do
  end
  
  it "should have new controller orders_controller method" do
    OrdersController.new.should respond_to(:new)
  end

  it "should have new controller order_items_controller" do
    OrderItemsController.should_not be_nil
  end

  it "should have new model order method" do
    Order.new.should respond_to(:extra_method)
  end

  it "should have new model order_item" do
    OrderItem.new.should respond_to(:order)
  end

  it "/orders should map to the orders_controller's index method" do
    route_for(:controller => 'orders', :action => 'index').should == '/orders'
    params_from(:get, "/orders").should == {:controller => "orders", :action => "index"}
  end

  it "new routes mapping should not break original mappings" do
    params_from(:get, "/users").should == {:controller => "users", :action => "index"}
  end

  describe "controllers & views" do
    before :each do
      @controller = OrdersController.new 
      @request = ActionController::TestRequest.new 
      @response = ActionController::TestResponse.new
    end

    it "/orders should get new response content" do
      get :index, :controller => :orders
      @response.should have_text("new index")
    end

    it "/orders/new should render new template" do
      get :new, :controller => :orders
      @response.should render_template("#{RAILS_ROOT}/vendor/modules/#{MOD_NAME}/app/views/orders/new.html.erb")
    end

    it "helper method should be able to used in new template" do
      get :new, :controller => :orders
      @response.should be_success
      @response.should include_text("new helper method")
    end
  end

  def controller_dir
    "#{RAILS_ROOT}/vendor/modules/#{MOD_NAME}/app/controllers"
  end

  def view_dir
    "#{RAILS_ROOT}/vendor/modules/#{MOD_NAME}/app/views"
  end

  def model_dir
    "#{RAILS_ROOT}/vendor/modules/#{MOD_NAME}/app/models"
  end

  def routes_path
    "#{RAILS_ROOT}/vendor/modules/#{MOD_NAME}/config/routes.rb"
  end

end
