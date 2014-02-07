require 'test_helper'

class NormalizerTest < MiniTest::Unit::TestCase
  def test_create
    assert Dockerc::Normalizer.new
  end

  def test_query_params
    n = Dockerc::Normalizer.new
    assert_equal({'command' => 'foo'}, n.to_query_params({:command => 'foo'}))
    assert_equal({'fromImage' => 'gorsuch/litterbox'}, n.to_query_params({:from_image => 'gorsuch/litterbox'}))
  end
end
