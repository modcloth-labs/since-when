require File.join(File.expand_path(File.dirname(__FILE__)), 'calculators/day_calculator')
require File.join(File.expand_path(File.dirname(__FILE__)), 'calculators/hour_calculator')

module SinceWhen
  class MissedRunCalculator
    VALID_INTERVALS = [:hour, :day]

    def initialize(meta, interval)
      @meta, @interval = meta, interval
    end

    def find
      raise ArgumentError, "invalid interval" unless valid?

      calculator_for_interval.new(meta.last_run).find
    end

    def find_each
      find.each do |time|
        yield time
      end
    end

    private

    def valid?
      VALID_INTERVALS.include? interval
    end

    def calculator_for_interval
      interval_name = interval.to_s.capitalize

      Calculators.const_get("#{interval_name}Calculator")
    end

    attr_reader :meta, :interval
  end
end
