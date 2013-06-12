require File.join(File.expand_path(File.dirname(__FILE__)), '../../../../lib/since_when/calculators/day_calculator')

describe SinceWhen::Calculators::DayCalculator do
  let(:date) { Date.new(2013, 6, 1) }

  before(:each) do
    Date.stub(:today).and_return(date)
  end

  context "no last run is given" do
    it "should calculate the current date as the only missed run" do
      described_class.new(nil).find.should == [date]
    end
  end

  context "a last run is given" do
    context "the last run was on the current date" do
      it "should calculate no dates" do
        described_class.new(date).find.should be_empty
      end
    end

    context "the last run was before the current date" do
      it "should calculate dates from the last run up to and including the current date" do
        described_class.new(date - 3).find.should == [
          Date.new(2013, 5, 29),
          Date.new(2013, 5, 30),
          Date.new(2013, 5, 31),
          Date.new(2013, 6, 1)
        ]
      end
    end
  end
end
