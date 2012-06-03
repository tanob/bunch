require "pathname"

require "bunch/version"
require "bunch/dsl"
require "bunch/definition"
require "bunch/repo"
require "bunch/git"

module Bunch
  def self.file
    Pathname.new(File.join(File.expand_path(Dir.pwd), "Bunchfile"))
  end
end

