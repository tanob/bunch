module Bunch
  class Repo
    attr_reader :group

    def initialize(git_repo, options)
      @git_repo = git_repo
      @group = options.delete(:group)
    end

    def clone!
      @git_repo.clone!
    end

    def execute_in_workdir(command)
      Kernel.system("cd #{@git_repo.directory} && #{command}")
    end
  end
end

