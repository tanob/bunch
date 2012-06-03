require "spec_helper"
require "bunch/cli"

describe Bunch::CLI do
  before do
    Bunch.stub!(:file => NotFoundBunchfile.new)
  end

  describe :clone do
    it "should clone all repos specified" do
      bunchfile <<-EOB
      repo "git@example.com:repo/repo1.git"
      repo "git@example.com:repo/repo2.git"
      EOB

      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/repo1.git')
      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/repo2.git')

      Bunch::CLI.start(["clone"])
    end

    it "should raise error if Bunchfile does not exist" do
      lambda {
        Bunch::CLI.start(["clone"])
      }.should raise_error('Bunchfile does not exist.')
    end

    it "should clone all repos in a group" do
      bunchfile <<-EOB
      group :apps do
        repo "git@example.com:repo/app1.git"
        repo "git@example.com:repo/app2.git"
      end
      repo "git@example.com:repo/repo.git"
      EOB

      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/app1.git')
      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/app2.git')

      Bunch::CLI.start(["clone", "-g", "apps"])
    end
  end

  def bunchfile(spec)
    Bunch.stub!(:file => FakeBunchfile.new(spec))
  end

  class FakeBunchfile
    def initialize(content)
      @content = content
    end

    def exist?
      true
    end

    def read
      @content
    end
  end

  class NotFoundBunchfile
    def exist?
      false
    end
  end
end

