require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A parsing expression" do
  setup do
    @expression = ParsingExpression.new
  end
  
  specify "returns a ZeroOrMore parsing expression with itself as the repeated expression on call to zero_or_more" do
    zero_or_more = @expression.zero_or_more
    zero_or_more.should_be_an_instance_of ZeroOrMore
    zero_or_more.repeated_expression.should_equal @expression
  end
  
  specify "returns a OneOrMore parsing expression with itself as the repeated expression on call to one_or_more" do
    zero_or_more = @expression.one_or_more
    zero_or_more.should_be_an_instance_of OneOrMore
    zero_or_more.repeated_expression.should_equal @expression
  end
  
  specify "returns an Optional parsing expression with itself as the repeated expression on call to one_or_more" do
    optional = @expression.optional
    optional.should_be_an_instance_of Optional
    optional.expression.should_equal @expression
  end
  
  specify "returns an AndPredicate parsing expression with itself as the predicated expression on call to and_predicate" do
    and_predicate = @expression.and_predicate
    and_predicate.should_be_an_instance_of AndPredicate
    and_predicate.expression.should_equal @expression
  end
  
  specify "returns a NotPredicate parsing expression with itself as the predicated expression on call to not_predicate" do
    and_predicate = @expression.not_predicate
    and_predicate.should_be_an_instance_of NotPredicate
    and_predicate.expression.should_equal @expression
  end
  
  specify "adds itself as an expected expression in the creation parse failures" do
    parse_result = @expression.send(:failure_at, 0)
    parse_result.failure_tree.expression.should == @expression
  end  
end