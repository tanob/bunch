require "thor"

module Bunch
  class CLI < Thor
    def self.group_option(desc)
      method_option :group,
        :type    => :array,
        :default => [],
        :aliases => "-g",
        :desc    => desc
    end

    desc "clone", "Clone the repos specified in Bunchfile"
    group_option "Clone only repos in the groups"
    def clone
      repos.each do |repo|
        Git.clone!(repo.spec)
      end
    end

    desc "foreach command", "Execute a command for each repo"
    group_option "Executes the command only for repos in the groups. Use -- to indicate the end of the group list and the start of the command to be executed."
    def foreach(*args)
      command = args.join(' ').gsub(/^\s*--?\s*/, '').strip
      raise "Command is empty!" if command.empty?

      repos.each do |repo|
        Kernel.system("cd #{repo.directory} && #{command}")
      end
    end

    desc "status", "Shows the repo working directory status"
    group_option "Shows the status only for the repos in the groups"
    def status
      command = "git status"

      repos.each do |repo|
        Kernel.system("cd #{repo.directory} && #{command}")
      end
    end

    private
    def bunch_spec
      raise 'Bunchfile does not exist.' unless Bunch.file.file?
      Bunch.file.read
    end

    def repos
      return @cached_repos if @cached_repos
      groups = options[:group].map(&:to_sym)

      definition = DSL.new(bunch_spec).to_definition
      @cached_repos = definition.repos_for(groups)
    end
  end
end

