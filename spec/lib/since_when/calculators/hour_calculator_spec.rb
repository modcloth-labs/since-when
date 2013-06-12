require File.join(File.expand_path(File.dirname(__FILE__)), '../../../../lib/since_when/calculators/hour_calculator')

describe SinceWhen::Calculators::HourCalculator do
  let(:time) { Time.utc(2013, 6, 1, 5, 30) }

  before(:each) do
    Time.stub(:now).and_return(time)
  end

  context "no last run is given" do
    it "should calculate the current hour as the only missed run" do
      described_class.new(nil).find.should == [Time.utc(2013, 6, 1, 5)]
    end
  end

  context "a last run is given" do
    context "the last run matches the current hour" do
      it "should calculate no runs" do
        described_class.new(time).find.should be_empty
      end
    end
  end

  context "the last run is before the current hour" do
    it "should calculate hours from the last run up to and including the current hour" do
      described_class.new(time - 3 * 60 * 60).find.should == [
        Time.utc(time.year, time.month, time.day, time.hour - 3),
        Time.utc(time.year, time.month, time.day, time.hour - 2),
        Time.utc(time.year, time.month, time.day, time.hour - 1),
        Time.utc(time.year, time.month, time.day, time.hour)
      ]
    end
  end
end
