require 'spec_helper'

describe Flight do
  it "should find flights in period" do
    a = Factory(:airport)
    f1 = Factory(:flight, :origin => a, :depart_date => Date.today, :return_date => Date.today + 2.weeks)
    f2 = Factory(:flight, :origin => a, :depart_date => Date.today + 2.months, :return_date => Date.today + 3.months)
    Flight.from_origin_in_period(a, Date.today, Date.today + 1.months).should == [f1]
  end
  
  it "should find flights by weeks" do
    a = Factory(:airport)
    f1 = Factory(:flight, :origin => a, :depart_date => Date.today, :return_date => Date.today + 2.weeks)
    f2 = Factory(:flight, :origin => a, :depart_date => Date.today, :return_date => Date.today + 1.weeks)
    Flight.return_weeks(2).should == [f1]
    Flight.return_weeks(1).should == [f2]
  end
  
  it "should find flights grouping by cheapest fare per destination" do
    a = Factory(:airport)
    a1 = Factory(:airport)
    a2 = Factory(:airport)
    f1 = Factory(:flight, :origin => a, :destination => a1, :depart_date => Date.today, :return_date => Date.today + 2.weeks, :value => 10)
    f2 = Factory(:flight, :origin => a, :destination => a1, :depart_date => Date.today, :return_date => Date.today + 1.weeks, :value => 20)
    f3 = Factory(:flight, :origin => a, :destination => a2, :depart_date => Date.today, :return_date => Date.today + 2.weeks, :value => 100)
    f4 = Factory(:flight, :origin => a, :destination => a2, :depart_date => Date.today, :return_date => Date.today + 1.weeks, :value => 200)
    Flight.scoped.cheapest_by_destination.should == [f1, f3]
  end
  
end
