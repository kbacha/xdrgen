require 'tempfile'

class Provider
  attr_reader :out

  def initialize
    @tempfile = Tempfile.new('output_file_provider')
    @out = Xdrgen::OutputFile.new(@tempfile.path)
  end

  def read
    @out.close
    File.read(@tempfile.path)
  end
end

module OutfileProvider
  def create_outfile_provider
    Provider.new
  end
end

RSpec.configure do |c|
  c.include OutfileProvider, :outfile
end
