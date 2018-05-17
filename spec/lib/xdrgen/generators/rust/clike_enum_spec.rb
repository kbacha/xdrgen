require 'spec_helper'

RSpec.describe Xdrgen::Generators::Rust::ClikeEnum do
  let(:klass) { described_class }

  it 'will camelize the ident' do
    expect(klass[identifier: 'HELLO'].identifier).to eq 'Hello'
    expect(klass[identifier: 'hello_world'].identifier).to eq 'HelloWorld'
  end
end
