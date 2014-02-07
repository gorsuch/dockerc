require 'test_helper'

class NormalizerTest < MiniTest::Unit::TestCase
  def test_create
    assert Dockerc::Normalizer.new
  end

  def test_query
    n = Dockerc::Normalizer.new
    assert_equal({'command' => 'foo'}, n.handle_request_query({:command => 'foo'}))
    assert_equal({'fromImage' => 'gorsuch/litterbox'}, n.handle_request_query({:from_image => 'gorsuch/litterbox'}))
    assert_equal({'all' => 1}, n.handle_request_query({:all => true}))
  end

  def test_response
    n = Dockerc::Normalizer.new
    assert_equal({:id => '12345', :warnings => []}, n.handle_response_data({'Id' => '12345', 'Warnings' => []}))
    assert_equal([{:id => '12345'}, {:id => '6789'}], n.handle_response_data([{'Id' => '12345'}, {'Id' => '6789'}]))
  end
end
