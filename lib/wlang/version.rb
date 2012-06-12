module WLang
  module Version

    MAJOR = 2
    MINOR = 0
    TINY  = 1

    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end

  end
  VERSION = Version.to_s
end
