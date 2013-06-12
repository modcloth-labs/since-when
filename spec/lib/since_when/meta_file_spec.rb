require File.join(File.expand_path(File.dirname(__FILE__)), '../../../lib/since_when/meta_file')

describe SinceWhen::MetaFile do
  let(:file) { double('file', readlines: ["2012-12-31 19:00:00"]) }
  let(:meta_file) { described_class.new("/tmp") }

  before(:each) do
    File.stub(:exists?).and_return(true)
    File.stub(:open).and_yield(file)
  end

  context "the given meta file exists" do
    context "the meta file contains the time of the last run" do
      it "should return the last run" do
        meta_file.last_run.should == Time.utc(2013, 1, 1)
      end
    end

    context "the meta file does not contain the time of the last run" do
      it "should return nil" do
        file.stub(:readlines).and_return([])

        meta_file.last_run.should be_nil
      end
    end

    context "the meta file contains an invalid time" do
      it "should return nil" do
        file.stub(:readlines).and_return(["ooh goody"])

        meta_file.last_run.should be_nil
      end
    end
  end

  context "the given meta file does not exist" do
    it "should return nil" do
      File.stub(:exists?).and_return(false)

      meta_file.last_run.should be_nil
    end
  end
end
