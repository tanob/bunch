module Bunch
  class Repo
    attr_reader :group

    def initialize(git_repo, options)
      @git_repo = git_repo
      @group    = options.delete(:group)
      @revision = options.delete(:revision)
    end

    def clone!
      @git_repo.clone!
      @git_repo.checkout!(@revision) if @revision
    end

    def execute_in_workdir(command)
      @git_repo.execute_in_workdir(command)
    end
  end
end

