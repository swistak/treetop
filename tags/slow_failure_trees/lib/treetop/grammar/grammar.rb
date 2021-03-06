module Treetop
  class Grammar
    attr_accessor :root, :builder
    
    def initialize(&block)
      @parsing_rules = Hash.new
      @nonterminal_symbols = Hash.new
      self.builder = GrammarBuilder.new(self)
      build &block if block
    end

    def new_parser
      Parser.new(self)
    end
    
    def nonterminal_symbol(ruby_sym)
      @nonterminal_symbols[ruby_sym] ||= NonterminalSymbol.new(ruby_sym, self)
    end
    
    def add_parsing_rule(parsing_rule_or_nonterminal, expression = nil)
      rule = make_parsing_rule(parsing_rule_or_nonterminal, expression)
      @parsing_rules[rule.nonterminal_symbol.name] = rule
      self.root ||= rule.nonterminal_symbol
    end
    
    def get_parsing_expression(nonterminal_symbol)
      if @parsing_rules[nonterminal_symbol.name]
        @parsing_rules[nonterminal_symbol.name].parsing_expression
      else
        raise "No parsing rule found named #{nonterminal_symbol}."
      end
    end
    
    def build(&block)
      builder.build &block
    end
    
    private
    def make_parsing_rule(rule_or_nonterminal, expression)
      if rule_or_nonterminal.is_a? NonterminalSymbol
        return ParsingRule.new(rule_or_nonterminal, expression)
      else
        return rule_or_nonterminal
      end
    end
  end
end