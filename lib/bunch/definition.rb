module Bunch
  class Definition
    attr_reader :repos

    def initialize(repos)
      @repos = repos
    end

    def repos_for(groups)
      @repos.select { |repo| groups.include? repo.group }
    end
  end
end

