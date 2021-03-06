require_relative 'calculator'

module SinceWhen
  module Calculators
    class HourCalculator < Calculator

      def interval_amt
        3600
      end

      private

      def start_of_interval(time)
        Time.utc(time.year, time.month, time.day, time.hour)
      end
    end
  end
end
