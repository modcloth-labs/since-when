module SinceWhen
  module Calculators
    class DayCalculator

      def initialize(last_run)
        @last_run = last_run
        @default = Date.today
      end

      def find
        if last_run.nil?
          [default]
        elsif equals?(last_run, default)
          []
        else
          upto(last_run, default)
        end
      end

      private

      attr_reader :last_run, :default

      def equals?(left, right)
        left == right
      end

      def upto(first, last)
        (first..last).to_a
      end
    end
  end
end
