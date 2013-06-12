require 'date'

module SinceWhen
  class MetaFile
    DEFAULT_PATH = File.join(File.expand_path(File.dirname(__FILE__)), '../..')

    attr_reader :meta_path

    def initialize(meta_path = DEFAULT_PATH)
      @meta_path = meta_path
    end

    def exists?
      File.exists?(meta_path)
    end

    def last_run
      fetch_last if exists?
    end

    def update!(new_date)
      File.open(meta_path, 'w') do |f|
        f.write(new_date.to_s)
      end
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

    def default_path
      DEFAULT_PATH
    end

    def parse(last)
      Date.parse(last.chomp) rescue nil
    end
  end
end
