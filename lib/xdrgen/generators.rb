module Xdrgen::Generators
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Go
  autoload :Java
  autoload :Javascript
  autoload :Ruby
  autoload :Rust

  def self.for_language(language)
    const_get language.to_s.classify
  rescue NameError
    raise ArgumentError, "Unsupported language: #{language}"
  end
end
