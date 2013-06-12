require File.join(File.expand_path(File.dirname(__FILE__)), 'calculators/day_calculator')
require File.join(File.expand_path(File.dirname(__FILE__)), 'calculators/hour_calculator')

module SinceWhen
  class MissedRunCalculator

    def initialize(meta)
      @meta = meta
    end

    def find_by_day
      Calculators::DayCalculator.new(meta.last_run).find
    end

    def find_by_hour
      Calculators::HourCalculator.new(meta.last_run).find
    end

    def find_each_by_day
      find_by_day.each do |day|
        yield day
      end
    end

    def find_each_by_hour
      find_by_hour.each do |time|
        yield time
      end
    end

    private

    attr_reader :meta
  end
end
