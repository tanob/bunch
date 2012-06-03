module Bunch
  class Repo
    attr_reader :spec, :group

    def initialize(spec, options)
      @spec = spec
      @group = options.delete(:group)
    end
  end
end

