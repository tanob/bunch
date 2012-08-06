module Bunch
  class Git
    def initialize(repo_spec)
      @repo_spec = repo_spec
    end

    def clone!
      Kernel.system("git clone #{@repo_spec}")
    end

    def checkout!(revision)
      execute_in_workdir("git checkout #{revision}")
    end

    def execute_in_workdir(command)
      Kernel.system("cd #{directory} && #{command}")
    end

    private
    def directory
      git_directory = @repo_spec.split("/").last
      git_directory.chomp(".git")
    end
  end
end

