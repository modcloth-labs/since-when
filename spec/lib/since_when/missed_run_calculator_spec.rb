require File.join(File.expand_path(File.dirname(__FILE__)), '../../../lib/since_when/missed_run_calculator')

describe SinceWhen::MissedRunCalculator do
  let(:time) { Time.utc(2013, 1, 1) }
  let(:meta) { double('meta', last_run: time) }

  it "should provide each day since the last run" do
    SinceWhen::Calculators::DayCalculator.any_instance.stub(:find).and_return([time])

    described_class.new(meta).find_by_day do |t|
      t.should == time
    end
  end

  it "should provide each hour since the last run" do
    SinceWhen::Calculators::HourCalculator.any_instance.stub(:find).and_return([time])

    described_class.new(meta).find_by_hour do |t|
      t.should == time
    end
  end
end
