module Bunch
  class Git
    def initialize(repo_spec)
      @repo_spec = repo_spec
    end

    def clone!
      Kernel.system("git clone #{@repo_spec}")
    end

    def directory
      git_directory = @repo_spec.split("/").last
      git_directory.chomp(".git")
    end
  end
end

