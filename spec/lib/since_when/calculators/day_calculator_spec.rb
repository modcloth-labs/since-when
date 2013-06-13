require_relative '../../../../lib/since_when/calculators/day_calculator'

describe SinceWhen::Calculators::DayCalculator do
  let(:time) { Time.utc(2013, 6, 1) }

  before(:each) do
    Time.stub(:now).and_return(time)
  end

  context "no last run is given" do
    it "should calculate the current date as the only missed run" do
      described_class.new(nil).find.should == [time]
    end
  end

  context "a last run is given" do
    context "the last run was on the current date" do
      it "should calculate no dates" do
        described_class.new(time).find.should be_empty
      end
    end

    context "the last run was before the current date" do
      it "should calculate dates from the last run up to and including the current date" do
        described_class.new(time - 3 * 3600 * 24).find.should == [
          Time.utc(2013, 5, 29),
          Time.utc(2013, 5, 30),
          Time.utc(2013, 5, 31),
          Time.utc(2013, 6, 1)
        ]
      end
    end
  end
end
