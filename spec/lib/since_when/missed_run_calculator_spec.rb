require_relative '../../../lib/since_when/missed_run_calculator'

describe SinceWhen::MissedRunCalculator do
  let(:time_one) { Time.utc(2013, 1, 1) }
  let(:time_two) { Time.utc(2013, 1, 2) }
  let(:meta) { double('meta', last_run: Time.now) }
  let(:runner) { described_class.new(meta) }

  before(:each) do
    SinceWhen::MetaFile.stub(:new).and_return(meta)

    meta.stub(:update!).and_return(true)

    described_class::VALID_INTERVALS.each do |interval|
      klass_name = "#{interval.to_s.capitalize}Calculator"
      klass = SinceWhen::Calculators.const_get(klass_name)

      klass.any_instance.stub(:find).and_return([time_one, time_two])
    end
  end

  context "finding the list of runtimes" do
    context "the given interval is valid" do
      described_class::VALID_INTERVALS.each do |interval|
        it "should provide return a list of runtimes by #{interval} since the last run" do
          runner.find(interval).should == [time_one, time_two]
        end
      end
    end

    context "the given interval is not valid" do
      it "should throw an error" do
        expect { runner.find(:cheese) }.to raise_error
      end
    end
  end

  context "the given interval is valid" do
    described_class::VALID_INTERVALS.each do |interval|
      it "should provide each #{interval} since the last run" do
        count = 0

        runner.find_each(interval) do |time|
          if count == 0
            time.should == time_one
          elsif count == 1
            time.should == time_two
          end
          count += 1
        end
      end

      context "all runtimes are run to completion" do
        it "should update the meta file to the final timestamp" do
          meta.should_receive(:update!).with(time_two)

          runner.find_each(interval) do |time|
            # noop
          end
        end

        context "the meta file is updated" do
          it "should return true" do
            result = runner.find_each(interval) do |time|
              # noop
            end

            result.should be_true
          end
        end

        context "the meta file is not updated" do
          it "should return false" do
            meta.stub(:update!).and_raise(IOError)

            result = runner.find_each(interval) do |time|
              # noop
            end

            result.should be_false
          end
        end
      end

      context "some of the runtimes are run to completion" do
        it "should update the meta file to the final completed timestamp" do
          count = 0
          meta.should_receive(:update!).with(time_one)

          runner.find_each(interval) do |time|
            raise RuntimeError if count == 1
            count += 1
          end
        end

        context "the meta file is updated" do
          it "should return true" do
            count = 0
            result = runner.find_each(interval) do |time|
              raise RuntimeError if count == 1
              count += 1
            end

            result.should be_true
          end
        end

        context "the meta file is not updated" do
          it "should return false" do
            meta.stub(:update!).and_raise(IOError)

            result = runner.find_each(interval) do |time|
              raise RuntimeError if count == 1

              count += 1
            end

            result.should be_false
          end
        end
      end

      context "no runtimes are run to completion" do
        it "should not update the meta file" do
          meta.should_not_receive(:update!)

          runner.find_each(interval) do |time|
            raise RuntimeError
          end
        end

        it "should return false" do
          result = runner.find_each(interval) do |time|
            raise RuntimeError
          end

          result.should be_false
        end
      end
    end
  end
end
