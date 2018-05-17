require 'spec_helper'

RSpec.describe Xdrgen::Generators::Rust::Comment do
  let(:klass) { described_class }

  describe '.render(out)', :outfile do
    let(:provider) { create_outfile_provider }

    it 'can create a comment' do
      klass[text: 'some text goes here'].render(provider.out)
      expect(provider.read).to eq "// some text goes here\n"
    end

    it 'will put each line on a new comment line' do
      klass[text: "some text\ngoes here"].render(provider.out)
      expect(provider.read).to eq "// some text\n// goes here\n"
    end
  end
end
