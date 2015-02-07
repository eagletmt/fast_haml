module FastHaml
  module FilterCompilers
    class NotFound < StandardError
      attr_reader

      def initialize(name)
        super("Unable to find compiler for #{name}")
        @name = name
      end
    end

    def self.compilers
      @compilers ||= {}
    end

    def self.register(name, compiler)
      compilers[name.to_s] = compiler
    end

    def self.find(name)
      name = name.to_s
      if compilers.has_key?(name.to_s)
        compilers[name].new
      else
        raise NotFound.new(name)
      end
    end
  end
end

require 'fast_haml/filter_compilers/javascript'
