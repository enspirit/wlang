module WLang
  class Source

    attr_reader :arg

    def initialize(arg)
      @arg = arg
    end

    def raw_text
      if to_path = looks_a_path?(@arg)
        File.read(@arg.send(to_path))
      elsif meth = looks_readable?(@arg)
        @arg.send(meth)
      else
        raise ArgumentError, "Invalid template source `#{@arg}`"
      end
    end
    alias :to_str :raw_text
    alias :to_s   :raw_text

  private

    def looks_a_path?(arg)
      [:path, :to_path].find{|m| arg.respond_to?(m)}
    end

    def looks_readable?(arg)
      [:read, :to_str].find{|m| arg.respond_to?(m)}
    end

  end # class Source
end # module WLang