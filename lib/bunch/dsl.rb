module Bunch
  class DSL
    def initialize(bunch_spec)
      @bunch_spec = bunch_spec
      @repos = []
      @current_group = :default
    end

    def to_definition
      instance_eval(@bunch_spec)
      Definition.new(@repos)
    end

    def group(name, &blk)
      @current_group = name
      yield
    ensure
      @current_group = :default
    end

    def repo(repo_spec)
      @repos << Repo.new(repo_spec, :group => @current_group)
    end
  end
end

