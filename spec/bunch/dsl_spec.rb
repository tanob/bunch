require 'spec_helper'

describe Bunch::DSL do
  it 'should return a bunch definition' do
    bunchfile = <<-EOB
    repo "git@example.com:repo/repo.git"
    EOB
    dsl = Bunch::DSL.new(bunchfile)
    definition = dsl.to_definition

    definition.should_not be_nil
    definition.repos.should have(1).repo

    repo = definition.repos.first
    repo.group.should == :default
  end

  it "should support group of repos" do
    bunchfile = <<-EOB
    group :apps do
      repo "git@example.com:repo/repo.git"
    end
    EOB

    dsl = Bunch::DSL.new(bunchfile)
    definition = dsl.to_definition
    definition.repos.should have(1).repo

    repo = definition.repos.first
    repo.group.should == :apps
  end
end

