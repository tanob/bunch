module Bunch
  class Definition
    attr_reader :repos

    def initialize(repos)
      @repos = repos
    end
  end
end

