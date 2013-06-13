require_relative '../../../lib/since_when/missed_runner'
require 'tmpdir'

describe SinceWhen::MissedRunner do
  let(:current_time) { Time.utc(2013, 6, 1, 8, 20, 15) }

  before(:all) do
    @meta_dir = Dir.mktmpdir('meta_dir')
    @meta_file = File.join(@meta_dir, 'test.meta')
  end

  before(:each) do
    Time.stub(:now).and_return(current_time)
  end

  context "running a repeated task for the first time" do
    it "should run the job for the first interval and update the meta file" do
      runtime = nil
      described_class.new(@meta_file).run(:day) do |time|
        runtime = time
      end

      runtime.should_not be_nil
      runtime.should == Time.utc(2013, 6, 1)

      File.exists?(@meta_file).should be_true
      File.open(@meta_file, 'r') do |f|
        f.readlines.first.should == "2013-06-01 00:00:00 UTC"
      end
    end
  end

  context "running a repeated task after the previous run" do
    it "should run the next job" do
      File.open(@meta_file, 'w') do |f|
        f.write(Time.utc(2013, 5, 31))
      end
      File.exists?(@meta_file).should be_true

      runtime = nil
      described_class.new(@meta_file).run(:day) do |time|
        runtime = time
      end

      runtime.should_not be_nil
      runtime.should == Time.utc(2013, 6, 1)

      File.exists?(@meta_file).should be_true
      File.open(@meta_file, 'r') do |f|
        f.readlines.first.should == "2013-06-01 00:00:00 UTC"
      end
    end
  end

  context "running a repeated task after a hiatus" do
    it "should run the job for all missed intervals and update the meta file" do
      times = [
        Time.utc(2013, 5, 29),
        Time.utc(2013, 5, 30),
        Time.utc(2013, 5, 31),
        Time.utc(2013, 6, 1)
      ]

      File.open(@meta_file, 'w') do |f|
        f.write(Time.utc(2013, 5, 28))
      end
      File.exists?(@meta_file).should be_true

      count = 0
      described_class.new(@meta_file).run(:day) do |time|
        times[count].should == time
        count += 1
      end
      count.should == 4

      File.exists?(@meta_file).should be_true
      File.open(@meta_file, 'r') do |f|
        f.readlines.first.should == "2013-06-01 00:00:00 UTC"
      end
    end
  end
end
