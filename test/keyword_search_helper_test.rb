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
    assert_equal %w(one two), @m.call('one two')[:keywords]
  end
  
  test "should extract double-quoted phrases into keywords array" do
    assert_equal ['single phrase','blah'], @m.call('"single phrase" blah')[:keywords]
  end
  
  test "when double-quoted only is extracted" do
    assert_equal ['single phrase'], @m.call('"single phrase"')[:keywords]
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
