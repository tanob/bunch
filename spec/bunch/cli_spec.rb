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

  describe :foreach do
    it "should execute the command for each of the repos" do
      bunchfile <<-EOB
      repo "git@example.com:repo/repo.git"
      EOB

      Kernel.should_receive(:system).with("cd repo && git status")

      Bunch::CLI.start(["foreach", "git", "status"])
    end

    it "should support foreach to a group of repos" do
      bunchfile <<-EOB
      group :testing do
        repo "git@example.com:repo/test1.git"
      end
      group :apps do
        repo "git@example.com:repo/app.git"
      end
      repo "git@example.com:repo/repo.git"
      EOB

      Kernel.should_receive(:system).with("cd test1 && git status")
      Kernel.should_receive(:system).with("cd app && git status")

      Bunch::CLI.start(["foreach", "-g", "testing", "apps", "--", "git", "status"])
    end
  end

  def bunchfile(spec)
    Bunch.stub!(:file => FakeBunchfile.new(spec))
  end

  class FakeBunchfile
    def initialize(content)
      @content = content
    end

    def file?
      true
    end

    def read
      @content
    end
  end

  class NotFoundBunchfile
    def file?
      false
    end
  end
end

