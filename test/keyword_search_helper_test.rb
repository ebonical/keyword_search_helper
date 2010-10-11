require 'test_helper'

class KeywordSearchHelperTest < ActiveSupport::TestCase
  
  test "returns empty hash when input is blank" do
    [nil, '', ' '].each do |str|
      assert_equal( {}, extract(str) )
    end
  end
  
  test "will split single words into array" do
    str = "one two"
    expected = {:keywords => %w(one two)}
    assert_equal expected, extract(str)
  end
  
  test "should extract double-quoted phrases into keywords array" do
    str = '"single phrase" blah'
    expected = {:keywords => ['single phrase','blah']}
    assert_equal expected, extract(str)
  end
  
  test "when double-quoted only is extracted" do
    str = '"single phrase"'
    expected = {:keywords => ['single phrase']}
    assert_equal expected, extract(str)
  end
  
  test "using an 'action'" do
    str = "tag:banana"
    expected = {:tag => ['banana']}
    assert_equal expected, extract(str)
  end
  
  test "using multiple actions" do
    str = "tag:banana since:2010-10-10"
    expected = {:tag => ["banana"], :since => ["2010-10-10"]}
    assert_equal expected, extract(str)
  end
  
  test "a combined query" do
    str = '"single phrase" tag:banana alone since:2010-10-10'
    expected = {:keywords => ['single phrase', 'alone'], :tag => ['banana'], :since => ['2010-10-10']}
    assert_equal expected, extract(str)
  end
  
  test "actions with double-quotes" do
    str = 'tag:"spaced tag"'
    expected = {:tag => ['spaced tag']}
    assert_equal expected, extract(str)
  end
  
  test "escaped $ dollar characters restored" do
    str = "$0"
    expected = {:keywords => ['$0']}
    assert_equal expected, extract(str)
  end
  
  test "only pick up on specific actions" do
    str = "ignore_action:banana use_action:fox"
    expected = {:use_action => ['fox'], :keywords => ["ignore_action:banana"]}
    assert_equal expected, extract(str, :only => :use_action)
  end
  
  test "multiple allowable actions" do
    options = {:only => [:tag, :name]}
    str = 'tag:banana name:"Big banana" kind:mp3'
    expected = {:keywords => ['kind:mp3'], :tag => ['banana'], :name => ['Big banana']}
    assert_equal expected, extract(str, options)
  end
  
  test "exclude certain actions" do
    options = {:exclude => [:name]}
    str = 'tag:banana name:Banana'
    expected = {:keywords => ['name:Banana'], :tag => ['banana']}
    assert_equal expected, extract(str, options)
  end
  
  test "should raise error when :only and :exclude are defined" do
    options = {:only => :tag, :exclude => :name}
    assert_raise ArgumentError do
      extract('', options)
    end
  end
  
  
  private
  
  def extract(input_string, options = {})
    KeywordSearchHelper.extract(input_string, options)
  end
end
