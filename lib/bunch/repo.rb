module Bunch
  class Repo
    attr_reader :spec, :group

    def initialize(spec, options)
      @spec = spec
      @group = options.delete(:group)
    end

    def directory
      git_directory = @spec.split("/").last
      git_directory.chomp(".git")
    end
  end
end

