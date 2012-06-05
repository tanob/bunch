require "spec_helper"
require "bunch/cli"

describe Bunch::CLI do
  before do
    Bunch.stub!(:file => NotFoundBunchfile.new)
  end

  describe :clone do
    it "should clone all repos specified" do
      bunchfile <<-EOB
      group :apps do
        repo "git@example.com:repo/repo1.git"
      end
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
      group :test do
        repo "git@example.com:repo/test.git"
      end
      repo "git@example.com:repo/repo.git"
      EOB

      Kernel.should_receive(:system).with("cd test && git status")
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

    it "should raise an error if command is not specified" do
      bunchfile <<-EOB
      repo "git@example.com:repo/repo.git"
      EOB

      lambda {
        Bunch::CLI.start(["foreach"])
      }.should raise_error("Command is empty!")
    end
  end

  describe :status do
    before do
      bunchfile <<-EOB
      repo "git@example.com:repo/repo1.git"
      group :test do
        repo "git@example.com:repo/repo2.git"
      end
      EOB
    end

    it "should show the git status for all repos" do
      Kernel.should_receive(:system).with("cd repo1 && git status")
      Kernel.should_receive(:system).with("cd repo2 && git status")

      Bunch::CLI.start(["status"])
    end

    it "should show the git status only for repos in the groups" do
      Kernel.should_receive(:system).with("cd repo2 && git status")

      Bunch::CLI.start(["status", "-g", "test"])
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

