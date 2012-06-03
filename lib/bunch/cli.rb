require "thor"

module Bunch
  class CLI < Thor
    desc "clone", "Clone the repos specified in Bunchfile"
    method_option :group,
      :type    => :array,
      :default => [:default],
      :aliases => "-g",
      :desc    => "Clone only repos in the group"
    def clone
      groups = options["group"].map(&:to_sym)
      definition = DSL.new(bunch_spec).to_definition

      definition.repos_for(groups).each do |repo|
        Git.clone!(repo.spec)
      end
    end

    desc "foreach command", "Execute a command for each repo"
    def foreach(*args)
      command = args.join(' ')
      definition = DSL.new(bunch_spec).to_definition

      definition.repos.each do |repo|
        Kernel.system("cd #{repo.directory} && #{command}")
      end
    end

    private
    def bunch_spec
      raise 'Bunchfile does not exist.' unless Bunch.file.file?
      Bunch.file.read
    end
  end
end

