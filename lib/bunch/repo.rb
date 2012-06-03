module Bunch
  class Repo
    attr_reader :spec

    def initialize(spec)
      @spec = spec
    end
  end
end

