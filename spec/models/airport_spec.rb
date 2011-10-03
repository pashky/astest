require 'spec_helper'

describe Airport do
  before do
    @led = Airport.create!(:code => 'LED', :name => 'Pulkovo', :latitude => 12, :longitude => 34)
    @svo = Airport.create!(:code => 'SVO', :name => 'Sheremetevo', :latitude => 12, :longitude => 34)
    @sh2 = Airport.create!(:code => 'SHT', :name => 'ShereSecond', :latitude => 12, :longitude => 34)
  end
  
  it "should be findable by code" do
    Airport.where(:code => 'LED').should include(@led)
  end
  
  it "shouldn't find anything else" do
    Airport.where(:code => 'LED').should_not include(@svo)
  end
  
  it "should be findable by name" do
    Airport.where("name like ?", "Pulkovo" + "%").should include(@led)
    Airport.where("name like ?", "Pulkovo" + "%").should_not include(@svo)
  end

  it "should return coordinates" do
    a = Airport.where(:code => 'LED').first
    a.latitude.should == 12
    a.longitude.should == 34
  end

  it "should return proper json" do
    json = @led.as_json
    json.should_not have_key("id")
    json.should have_key("code")
    json.should have_key("name")
    json.should have_key("latitude")
    json.should have_key("longitude")
  end

end
