require 'spec_helper'

describe FlightSearchController do
  
  it "should respond successfully" do
    get :search, :format => :json
    response.should be_success
  end

  it "should run search" do
    search = FlightSearch.new
    FlightSearch.stub(:new).and_return(search)
    search.should_receive(:find_cheapest).with({:from => nil, :date => nil, :period => nil, :weeks => nil}).and_return(search)
    get :search, :format => :json
  end

  it "should return search result body as json" do
    search = {}
    FlightSearch.stub(:new).and_return(search)
    message = { :test => "me" }
    search.should_receive(:find_cheapest).and_return(message)
    get :search, :format => :json
    response.body.should == message.to_json
  end

end
