require_relative '../../../../lib/since_when/calculators/day_calculator'

describe SinceWhen::Calculators::DayCalculator do
  let(:previous) { Time.utc(2013, 5, 31) }
  let(:current) { Time.utc(2013, 6, 1) }

  before(:each) do
    Time.stub(:now).and_return(current)
  end

  context "no last run is given" do
    it "should calculate the previous date as the only missed run" do
      described_class.new(nil).find.should == [previous]
    end
  end

  context "a last run is given" do
    context "the last run was on the previous date" do
      it "should calculate no dates" do
        described_class.new(previous).find.should be_empty
      end
    end

    context "the last run was before the previous date" do
      it "should calculate dates from the last run up to and including the previous date" do
        described_class.new(previous - 3 * 3600 * 24).find.should == [
          Time.utc(2013, 5, 29),
          Time.utc(2013, 5, 30),
          Time.utc(2013, 5, 31),
        ]
      end
    end
  end
end
