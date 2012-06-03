require "thor"

module Bunch
  class CLI < Thor
    desc "clone", "Clone the repos specified in Bunchfile"
    method_option :group, :type => :array, :default => [:default], :aliases => "-g", :desc => "Clone only repos in the group"
    def clone
      groups = options["group"].map(&:to_sym)
      bunch_spec = IO.read(bunchfile)
      definition = DSL.new(bunch_spec).to_definition

      definition.repos_for(groups).each do |repo|
        Git.clone!(repo.spec)
      end
    end

    private
    def bunchfile
      bunchfile = File.join(File.expand_path(Dir.pwd), "Bunchfile")
      raise 'Bunchfile does not exist.' unless File.file?(bunchfile)
      bunchfile
    end
  end
end

