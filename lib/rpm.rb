require 'bigdecimal'

class Rpm
  def initialize(expression, operator_class = BigDecimal)
    self.expression = expression
    self.operator_class = operator_class
    self.operator = operator_class.new("0")
    self.stack = []
    self.total = 0
  end

  def calculate
    raise "Expression not given" if expression.nil? || expression.empty?

    pool.each do |item|
      if item.is_a?(Integer) || item.match(/\d+/)
        stack.push operator_class.new(item.to_s)
      elsif operator.respond_to?(item.to_s)
        first, second = stack.pop(2)
        sub_total = first.send(item, second)
        stack.push sub_total

        self.total = sub_total
      else
        raise "Operator #{item} not valid"
      end
    end

    total
  end

  private

  attr_accessor :expression, :total, :stack, :operator_class, :operator

  def pool
    @pool ||= if expression.is_a?(String)
                expression.split(" ")
              else
                expression
              end
  end
end
