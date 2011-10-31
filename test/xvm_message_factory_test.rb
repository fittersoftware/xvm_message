require '../lib/xvm_message/xvm_message_factory'
require '../lib/xvm_message/xvm_message'
require 'test/unit'

class XvmMessageFactoryTest < Test::Unit::TestCase

  test 'build the correct xvm type based on the string message' do
    string_message = '>RGP010100000019+0000000+000000000000000FF1F0000;ID=1234;#827F;*53<'
    m = Xvm::XvmMessageFactory.create_message(string_message)
    assert_true m.is_a? Xvm::GeopositionMessage

    string_message = '>RUS00,280711165512, 000000300, 000000000, 000001300, 000000000;ID=1234;#0653;*62<'
    m = Xvm::XvmMessageFactory.create_message(string_message)
    assert_true m.is_a? Xvm::PerformanceMessage

    string_message = '>hello;ID=1222;#014B;*00<'
    m = Xvm::XvmMessageFactory.create_message(string_message)
    assert_true m.is_a? Xvm::XvmMessage # a raw one.

  end

  test 'if is a geoposition message' do
    assert_true Xvm::XvmMessageFactory.is_geoposition?('>RGP010100000019+0000000+000000000000000FF1F0000;ID=1234;#827F;*53<')
  end

  test 'if is a ping message with virloc firmware version' do
    assert_true Xvm::XvmMessageFactory.is_ping?('>RVR VIRTUALTEC VIRLOC10 BR156 VL10_123 FVR123 VR123 FT2EON;ID=1234;#0231;*0F<')
  end

  test 'if is a rus00 report with canbus data' do
    assert_true Xvm::XvmMessageFactory.is_rus00?('>RUS00,280711165512, 000000300, 000000000, 000001300, 000000000;ID=1234;#0653;*62<')
  end

end