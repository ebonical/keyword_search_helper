require 'test_helper'

class KeywordSearchHelperTest < ActiveSupport::TestCase
  setup do
    @m = Proc.new { |string| KeywordSearchHelper.extract(string) }
  end
  
  # Replace this with your real tests.
  test "returns empty hash when input is blank" do
    [nil, '', ' '].each do |str|
      assert_equal( {}, @m.call(str) )
    end
  end
  
  test "will split single words into array" do
    str = "one two"
    expected = {:keywords => %w(one two)}
    assert_equal expected, @m.call(str)
  end
  
  test "should extract double-quoted phrases into keywords array" do
    str = '"single phrase" blah'
    expected = {:keywords => ['single phrase','blah']}
    assert_equal expected, @m.call(str)
  end
  
  test "when double-quoted only is extracted" do
    str = '"single phrase"'
    expected = {:keywords => ['single phrase']}
    assert_equal expected, @m.call(str)
  end
  
  test "using an 'action'" do
    str = "tag:banana"
    expected = {:tag => ['banana']}
    assert_equal expected, @m.call(str)
  end
  
  test "using multiple actions" do
    str = "tag:banana since:2010-10-10"
    expected = {:tag => ["banana"], :since => ["2010-10-10"]}
    assert_equal expected, @m.call(str)
  end
  
  test "a combined query" do
    str = '"single phrase" tag:banana alone since:2010-10-10'
    expected = {:keywords => ['single phrase', 'alone'], :tag => ['banana'], :since => ['2010-10-10']}
    assert_equal expected, @m.call(str)
  end
  
  test "actions with double-quotes" do
    str = 'tag:"spaced tag"'
    expected = {:tag => ['spaced tag']}
    assert_equal expected, @m.call(str)
  end
end
