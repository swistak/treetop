require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the block rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :block
  end

  specify "parses an empty block" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('{}')
      result.should be_success
      result.value.should == ""
    end
  end
  
  specify "parses an otherwise empty block with space between the braces" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('{   }')
      result.should be_success
      result.value.should == "   "
    end
  end

  specify "parses a block with characters other than curly braces between its braces" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      text = "some_text"
      result = parser.parse("{#{text}}")
      result.should be_success
      result.value.should == text
    end
  end

  specify "parses a block with Ruby code that uses blocks in it" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      ruby_code = "[1, 2, 3].map {|x| x + 1}"
      block = "{#{ruby_code}}"
      result = parser.parse(block)
      result.should be_success
      result.value.should == ruby_code
    end
  end
  
  specify "parses a block with newlines in it" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("{\ndef a_method\n\nend\n}")
      result.should be_success
    end
  end
end