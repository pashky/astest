require 'spec_helper'

describe FlightSearch do
  it "should fail on bad parameters" do
    FlightSearch.find_by_cheapest(:from => "").errors[:from].should_not be_empty
    FlightSearch.find_by_cheapest(:from => nil).errors[:from].should_not be_empty
    FlightSearch.find_by_cheapest(:date => nil).errors[:date].should_not be_empty
    FlightSearch.find_by_cheapest(:date => "").errors[:date].should_not be_empty 
    FlightSearch.find_by_cheapest(:date => "xxx").errors[:date].should_not be_empty
    FlightSearch.find_by_cheapest(:date => "2012-56-78").errors[:date].should_not be_empty
    FlightSearch.find_by_cheapest(:weeks => "-1").errors[:weeks].should_not be_empty
    FlightSearch.find_by_cheapest(:period => nil).errors[:period].should_not be_empty
    FlightSearch.find_by_cheapest(:period => "year").errors[:period].should_not be_empty
  end

  it "should fail on unknown airport" do
    s = FlightSearch.find_by_cheapest(:from => "XXX", :date => '2011-01-01', :period => 'month')
    s.errors[:from].should_not be_empty
    s.errors[:from].should include("is not found")
  end
  
  it "should find existing airport" do
    led = Airport.create!(:code => 'LED', :name => 'Pulkovo', :latitude => 12, :longitude => 34)
    
    s = FlightSearch.find_by_cheapest(:from => "LED", :date => '2011-01-01', :period => 'month')
    s.errors[:from].should be_empty

    s.origin.should == led
  end
  
  it "should find flights according to specified time" do
    a = Factory(:airport, :id => 1)
    a1 = Factory(:airport, :id => 2)
    a2 = Factory(:airport, :id => 3)
    
    f1 = Factory(:flight, :origin => a, :destination => a1)
    f2 = Factory(:flight, :origin => a, :destination => a2, :depart_date => Date.today + 2.months, :return_date => Date.today + 2.months + 1.weeks)
    
    s = FlightSearch.find_by_cheapest(:from => "LED", :date => Date.today.to_s, :period => 'season')
    s.errors[:from].should be_empty
    s.results.should == [f1, f2]
    
    s = FlightSearch.find_by_cheapest(:from => "LED", :date => Date.today.to_s, :period => 'month')
    s.errors[:from].should be_empty
    s.results.should == [f1]
    
    s = FlightSearch.find_by_cheapest(:from => "LED", :date => Date.today.to_s, :period => 'season', :weeks => 1)
    s.errors[:from].should be_empty
    s.results.should == [f2]
  end
  
  it "should find flights with minimal price" do
    a = Factory(:airport, :id => 1)
    a1 = Factory(:airport, :id => 2)
    a2 = Factory(:airport, :id => 3)
    
    f1 = Factory(:flight, :origin => a, :destination => a1, :value => 10)
    f2 = Factory(:flight, :origin => a, :destination => a1, :value => 20)
    f3 = Factory(:flight, :origin => a, :destination => a2, :value => 200)
    f4 = Factory(:flight, :origin => a, :destination => a2, :value => 100)
    
    s = FlightSearch.find_by_cheapest(:from => "LED", :date => Date.today.to_s, :period => 'season')
    s.errors[:from].should be_empty
    s.results.should == [f1, f4]
  end
end
