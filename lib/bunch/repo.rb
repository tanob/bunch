module Bunch
  class Repo
    attr_reader :group

    def initialize(spec, options)
      @spec = spec
      @group = options.delete(:group)
    end

    def clone!
      Git.clone!(@spec)
    end

    def execute_in_workdir(command)
      Kernel.system("cd #{directory} && #{command}")
    end

    private
    def directory
      git_directory = @spec.split("/").last
      git_directory.chomp(".git")
    end
  end
end

