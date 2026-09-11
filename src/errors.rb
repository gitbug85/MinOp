# Use rainbow gem

class Location
    def initialize: (Integer col, Integer ln)
        @col = col
        @ln = ln
    end

    def to_s()
        return ""
    end
end

class Error
    def initialize: (Location where, String why, String how)
    end
end