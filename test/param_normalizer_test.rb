require 'test_helper'

class ParamNormalizerTest < MiniTest::Unit::TestCase
  def test_create
    assert Dockerc::ParamNormalizer.new
  end

  def test_normalize_incoming_params
    n = Dockerc::ParamNormalizer.new
    assert_equal :command, n.for_inbound('Command')
  end

  def test_normaliz_outgoing_params
    n = Dockerc::ParamNormalizer.new
    assert_equal 'Command', n.for_outbound(:command)
    assert_equal 'AttachStdin', n.for_outbound(:attach_stdin)
  end
end
