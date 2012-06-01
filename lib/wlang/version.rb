module WLang
  module Version

    MAJOR = 2
    MINOR = 0
    TINY  = 0
    BETA  = "beta"

    def self.to_s
      [ MAJOR, MINOR, TINY, BETA ].join('.')
    end

  end
  VERSION = Version.to_s
end
