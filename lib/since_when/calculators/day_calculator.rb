require File.join(File.expand_path(File.dirname(__FILE__)), 'calculator')

module SinceWhen
  module Calculators
    class DayCalculator < Calculator

      def initialize(last_run)
        super(last_run)
        @interval_amt = 3600 * 24
      end

      private

      def increment(time)
        start_of_interval(time + 3600 * 24)
      end

      def start_of_interval(time)
        Time.utc(time.year, time.month, time.day)
      end
    end
  end
end
