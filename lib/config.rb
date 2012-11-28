module WeiboCrawler
  module Config

    def self.db_host=(val)
      @@db_host = val
    end

    def self.db_host
      @@db_host
    end

    def self.db_port=(val)
      @@db_port = val
    end

    def self.db_port
      @@db_port
    end

    def self.db_name=(val)
      @@db_name = val
    end

    def self.db_name
      @@db_name
    end
    
  end
end