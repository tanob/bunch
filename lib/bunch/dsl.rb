module Bunch
  class DSL
    def initialize(bunch_spec)
      @bunch_spec = bunch_spec
      @repos = []
    end

    def to_definition
      instance_eval(@bunch_spec)
      Definition.new(@repos)
    end

    def repo(repo_spec)
      @repos << Repo.new(repo_spec)
    end
  end
end

