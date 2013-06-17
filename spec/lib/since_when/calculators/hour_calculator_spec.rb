require_relative '../../../../lib/since_when/calculators/hour_calculator'

describe SinceWhen::Calculators::HourCalculator do
  let(:previous) { Time.utc(2013, 6, 1, 4) }
  let(:current) { Time.utc(2013, 6, 1, 5, 30) }

  before(:each) do
    Time.stub(:now).and_return(current)
  end

  context "no last run is given" do
    it "should calculate the previous hour as the only missed run" do
      described_class.new(nil).find.should == [previous]
    end
  end

  context "a last run is given" do
    context "the last run matches the previous hour" do
      it "should calculate no runs" do
        described_class.new(previous).find.should be_empty
      end
    end
  end

  context "the last run is before the current hour" do
    it "should calculate hours from the last run up to and including the previous hour" do
      described_class.new(previous - 3 * 60 * 60).find.should == [
        Time.utc(2013, 6, 1, 2),
        Time.utc(2013, 6, 1, 3),
        Time.utc(2013, 6, 1, 4)
      ]
    end
  end
end
