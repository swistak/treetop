module ParsingExpressionBuilderHelper
  attr_accessor :grammar
  
  def nonterm(symbol)
    grammar.nonterminal_symbol(symbol)
  end
  
  def term(string)
    TerminalSymbol.new(string)
  end

  def exp(object, &block)
    exp = case object
          when String
            term(object)
          when Symbol
            nonterm(object)
          when ParsingExpression
            object
          when Array
            object.map { |elt| exp(elt) }
          else raise "Argument must be an instance of String, Symbol, or ParsingExpression"
          end
    exp.node_class_eval &block if block
    exp
  end
  
  def any
    AnythingSymbol.new
  end
  
  def char_class(char_class_string)
    CharacterClass.new(char_class_string)
  end
  
  def andp(expression)
    exp(expression).and_predicate
  end
  
  def notp(expression)
    exp(expression).not_predicate
  end
  
  def optional(expression)
    exp(expression).optional
  end
  
  def seq(*expressions, &block)
    sequence = Sequence.new(exp(expressions))
    sequence.node_class_eval &block if block
    return sequence
  end
  
  def choice(*expressions)
    OrderedChoice.new(exp(expressions))
  end
  
  def zero_or_more(expression)
    exp(expression).zero_or_more
  end

  def one_or_more(expression)
    exp(expression).one_or_more
  end

  def escaped(character)
    seq('\\', character)
  end

  def n_or_more_delimited(n, expression, delimiter, &block)
    expression = exp(expression)
    delimiter = exp(delimiter)
    
    head_element = delimited_sequence_head_element(n, expression)
    tail_element = delimited_sequence_tail_element(n, expression, delimiter)
    
    if n > 1
      tail_elements = one_or_more(tail_element)
    else
      tail_elements = zero_or_more(tail_element)
    end
    
    tail_elements.node_class_eval do
      def elements
        super.map(&:element)
      end
    end
    
    delimited_sequence = seq(head_element, tail_elements) do
      def elements
        return [] if super[0].empty?
        [super[0]] + super[1].elements
      end
    end
    
    delimited_sequence.node_class_eval(&block) if block
    return delimited_sequence
  end
  
  def delimited_sequence_head_element(n, expression)
    n == 0 ? optional(expression) : expression
  end
  
  def delimited_sequence_tail_element(n, expression, delimiter)
    seq(delimiter, expression) do
      def element
        elements[1]
      end
    end
  end
  
  def zero_or_more_delimited(expression, delimiter, &block)
    n_or_more_delimited(0, expression, delimiter, &block)
  end
  
  def two_or_more_delimited(expression, delimiter, &block)
    n_or_more_delimited(2, expression, delimiter, &block)    
  end
end