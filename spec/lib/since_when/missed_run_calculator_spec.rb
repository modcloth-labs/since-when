require File.join(File.expand_path(File.dirname(__FILE__)), '../../../lib/since_when/missed_run_calculator')

describe SinceWhen::MissedRunCalculator do
  let(:time) { Time.utc(2013, 1, 1) }
  let(:meta) { double('meta', last_run: time) }


  context "the given interval is valid" do
    described_class::VALID_INTERVALS.each do |interval|
      it "should provide each #{interval} since the last run" do
        SinceWhen::Calculators.const_get("#{interval.to_s.capitalize}Calculator").
          any_instance.stub(:find).and_return([time])

        described_class.new(meta, interval).find do |t|
          t.should == time
        end
      end
    end
  end

  context "the given interval is not valid" do
    it "should throw an error" do
      expect { described_class.new(meta, :goat).find }.to raise_error
    end
  end
end
