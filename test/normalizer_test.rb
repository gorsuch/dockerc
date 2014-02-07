require 'test_helper'

class NormalizerTest < MiniTest::Unit::TestCase
  def test_create
    assert Dockerc::Normalizer.new
  end

  def test_query_params
    n = Dockerc::Normalizer.new
    assert_equal({'command' => 'foo'}, n.handle_request_query({:command => 'foo'}))
    assert_equal({'fromImage' => 'gorsuch/litterbox'}, n.handle_request_query({:from_image => 'gorsuch/litterbox'}))
    assert_equal({'all' => 1}, n.handle_request_query({:all => true}))
  end
end
