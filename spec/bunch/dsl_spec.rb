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
  end
end

