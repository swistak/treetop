require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the suffix rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :suffix
  end

  specify "parses a * to a node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('*')
    
      parsing_expression = mock('expression preceding the suffix')
      zero_or_more = mock('zero or more of the parsing expression')
      parsing_expression.should_receive(:zero_or_more).and_return(zero_or_more)
    
      result.value(parsing_expression).should == zero_or_more
    end
  end

  specify "parses a + node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('+')
    
      parsing_expression = mock('expression preceding the suffix')
      one_or_more = mock('one or more of the parsing expression')
      parsing_expression.should_receive(:one_or_more).and_return(one_or_more)
    
      result.value(parsing_expression).should == one_or_more
    end
  end

  specify "parses a ? node that can modify the semantics of an expression it follows appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('?')
    
      parsing_expression = mock('expression preceding the suffix')
      optional = mock('optional parsing expression')
      parsing_expression.should_receive(:optional).and_return(optional)
    
      result.value(parsing_expression).should == optional
    end
  end
end