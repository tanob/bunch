require "spec_helper"

describe Bunch do
  describe :file do
    it "should return a reference to the current directory's Bunchfile" do
      Dir.should_receive(:pwd).and_return('/tmp')

      Bunch.file.should == Pathname.new('/tmp/Bunchfile')
    end
  end
end

