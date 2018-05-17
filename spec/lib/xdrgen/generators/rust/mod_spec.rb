require 'spec_helper'

RSpec.describe Xdrgen::Generators::Rust::Mod do
  let(:klass) { described_class }

  it 'will underscore the ident' do
    expect(klass[identifier: 'HELLO'].identifier).to eq 'hello'
    expect(klass[identifier: 'hello_world'].identifier).to eq 'hello_world'
    expect(klass[identifier: 'HelloWorld'].identifier).to eq 'hello_world'
  end

  describe '.to_rust(out)', :outfile do
    let(:provider) { create_outfile_provider }

    it 'can create the namespace in rust' do
      klass[identifier: 'hello_world'].render(provider.out)
      expect(provider.read).to eq(<<~RUST)
      mod hello_world {
      }
      RUST
    end

    it 'includes inner renders as well' do
      klass[
        identifier: 'hello_world',
        inners: [
            Xdrgen::Generators::Rust::Comment[text: 'inside the module']
        ]
      ].render(provider.out)
      expect(provider.read).to eq(<<~RUST)
      mod hello_world {
          // inside the module
      }
      RUST
    end
  end
end
