require 'date'
require 'time'

module SinceWhen
  class MetaFile
    attr_reader :meta_path

    def initialize(meta_path)
      @meta_path = meta_path
    end

    def exists?
      File.exists?(meta_path)
    end

    def last_run
      fetch_last if exists?
    end

    def update!(new_time)
      written = 0
      File.open(meta_path, 'w') do |f|
        written = f.write(new_time.to_s)
      end

      written > 0
    end

    private

    def fetch_last
      last = read_last

      parse(last) unless last.nil?
    end

    def read_last
      last = nil
      File.open(meta_path, 'r') do |f|
        last = f.readlines.first
      end

      last
    end

    def parse(last)
      Time.parse(last.chomp).utc rescue nil
    end
  end
end
