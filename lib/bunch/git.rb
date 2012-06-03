module Bunch
  class Git
    def self.clone!(repo_spec)
      Kernel.system("git clone #{repo_spec}")
    end
  end
end

