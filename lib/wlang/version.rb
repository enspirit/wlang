module WLang
  module Version

    MAJOR = 2
    MINOR = 1
    TINY  = 2

    def self.to_s
      [ MAJOR, MINOR, TINY ].join('.')
    end

  end
  VERSION = Version.to_s
end
