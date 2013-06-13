require_relative 'calculators/day_calculator'
require_relative 'calculators/hour_calculator'
require_relative 'meta_file'

module SinceWhen
  class MissedRunner
    VALID_INTERVALS = [:hour, :day]

    def initialize(meta_path)
      @meta = MetaFile.new(meta_path)
    end

    def find(interval)
      raise ArgumentError, "invalid interval" unless valid?(interval)

      calculator_for(interval).new(meta.last_run).find
    end

    def run(interval)
      last, updated = nil, false

      begin
        find(interval).each do |time|
          yield time

          last = time
        end
      rescue Exception => e
        #$stderr.puts "Didn't update meta file, failed execution"
      ensure
        updated = update_meta(last)
      end

      updated
    end

    private

    attr_reader :meta, :interval

    def update_meta(last)
      unless last.nil?
        meta.update!(last) rescue false
      end
    end

    def valid?(interval)
      VALID_INTERVALS.include?(interval)
    end

    def calculator_for(interval)
      Calculators.const_get("#{interval.to_s.capitalize}Calculator")
    end
  end
end
