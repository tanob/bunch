require "spec_helper"

describe Bunch::Git do
  describe :clone do
    it "should git clone the repo specified by spec" do
      Kernel.should_receive(:system).with("git clone git@example.com:repo/repo.git")

      Bunch::Git.clone!("git@example.com:repo/repo.git")
    end
  end
end
