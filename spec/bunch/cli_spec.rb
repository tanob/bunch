require "spec_helper"
require "bunch/cli"

describe Bunch::CLI do
  describe :clone do
    it "should clone all repos specified" do
      bunch_spec = <<-EOB
      repo "git@example.com:repo/repo1.git"
      repo "git@example.com:repo/repo2.git"
      EOB

      Bunch::CLI.any_instance.stub(:bunchfile => "Bunchfile")
      IO.should_receive(:read).with("Bunchfile").and_return(bunch_spec)

      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/repo1.git')
      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/repo2.git')

      Bunch::CLI.start(["clone"])
    end

    it "should raise error if Bunchfile does not exist" do
      File.should_receive(:file?).and_return(false)

      lambda {
        Bunch::CLI.start(["clone"])
      }.should raise_error('Bunchfile does not exist.')
    end

    it "should clone all repos under a group" do
      bunch_spec = <<-EOB
      group :apps do
        repo "git@example.com:repo/app1.git"
        repo "git@example.com:repo/app2.git"
      end
      repo "git@example.com:repo/repo.git"
      EOB

      Bunch::CLI.any_instance.stub(:bunchfile => "Bunchfile")
      IO.should_receive(:read).with("Bunchfile").and_return(bunch_spec)

      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/app1.git')
      Bunch::Git.should_receive(:clone!).with('git@example.com:repo/app2.git')

      cmd, args = Bunch::CLI.start(["clone", "-g", "apps"])
    end
  end
end

