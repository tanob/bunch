require "thor"

module Bunch
  class CLI < Thor
    desc "clone", "Clone the repos specified in Bunchfile"
    method_option :group,
      :type    => :array,
      :default => [],
      :aliases => "-g",
      :desc    => "Clone only repos in the group"
    def clone
      groups = options[:group].map(&:to_sym)
      definition = DSL.new(bunch_spec).to_definition

      definition.repos_for(groups).each do |repo|
        Git.clone!(repo.spec)
      end
    end

    desc "foreach command", "Execute a command for each repo"
    method_option :group,
      :type    => :array,
      :default => [],
      :aliases => "-g",
      :desc    => "Executes the command only for repos in the groups. Use -- to indicate the end of the group list and the start of the command to be executed."
    def foreach(*args)
      groups = options[:group].map(&:to_sym)
      command = args.join(' ').gsub(/^\s*--?\s*/, '').strip

      raise "Command is empty!" if command.empty?

      definition = DSL.new(bunch_spec).to_definition
      definition.repos_for(groups).each do |repo|
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

