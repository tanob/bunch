require "thor"

module Bunch
  class CLI < Thor
    desc "clone", "Clone the repos specified in Bunchfile"
    def clone
      bunch_spec = IO.read(bunchfile)
      definition = DSL.new(bunch_spec).to_definition

      definition.repos.each do |repo|
        Git.clone!(repo.spec)
      end
    end

    private
    def bunchfile
      bunchfile = File.join(File.expand_path(Dir.pwd), 'Bunchfile')
      raise 'Bunchfile does not exist.' unless File.file?(bunchfile)
      bunchfile
    end
  end
end

