require_relative '../../../lib/since_when/missed_runner'

describe SinceWhen::MissedRunner do
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

        runner.run(interval) do |time|
          if count == 0
            time.should == time_one
          elsif count == 1
            time.should == time_two
          end
          count += 1
        end
      end

      context "all jobs are run without error" do
        context "jobs runtimes are run successfully" do
          it "should update the meta file to the final timestamp" do
            meta.should_receive(:update!).with(time_two)

            runner.run(interval) do |time|
              true
            end
          end

          context "the meta file is updated" do
            it "should return true" do
              result = runner.run(interval) do |time|
                true
              end

              result.should be_true
            end
          end

          context "the meta file is not updated" do
            it "should return false" do
              meta.stub(:update!).and_raise(IOError)

              result = runner.run(interval) do |time|
                true
              end

              result.should be_false
            end
          end
        end

        context "one of the runtimes runs with a failure" do
          it "should update the meta file to the final completed timestamp" do
            meta.should_receive(:update!).with(time_one)

            ran_once = false
            runner.run(interval) do |time|
              if ran_once
                nil
              else
                ran_once = true
                true
              end
            end
          end
        end

        context "the first job runs without a failure" do
          it "should not update the meta file" do
            meta.should_not_receive(:update!)

            runner.run(interval) do |time|
              false
            end
          end
        end
      end

      context "one of the running jobs raises an error" do
        it "should update the meta file to the final completed timestamp" do
          count = 0
          meta.should_receive(:update!).with(time_one)

          runner.run(interval) do |time|
            raise RuntimeError if count == 1
            count += 1
            true
          end
        end

        context "the meta file is updated" do
          it "should return true" do
            count = 0
            result = runner.run(interval) do |time|
              raise RuntimeError if count == 1
              count += 1
              true
            end

            result.should be_true
          end
        end

        context "the meta file is not updated" do
          it "should return false" do
            meta.stub(:update!).and_raise(IOError)

            result = runner.run(interval) do |time|
              raise RuntimeError if count == 1

              count += 1
              true
            end

            result.should be_false
          end
        end
      end

      context "the first run job raises an error" do
        it "should not update the meta file" do
          meta.should_not_receive(:update!)

          runner.run(interval) do |time|
            raise RuntimeError
          end
        end

        it "should return false" do
          result = runner.run(interval) do |time|
            raise RuntimeError
          end

          result.should be_false
        end
      end
    end
  end
end
