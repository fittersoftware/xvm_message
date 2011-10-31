require '../lib/xvm_message/xvm_message'
require 'test/unit'

class XvmMessageTest < Test::Unit::TestCase

  test 'is_valid? class method validates the format of a message ' do
    assert_false Xvm::XvmMessage.is_valid? 'hello world'
    assert_true Xvm::XvmMessage.is_valid? '>RDB11 01 01;ID=1234;#8284;*40<'
    assert_true Xvm::XvmMessage.is_valid? '>hello;ID=1222;#014B;*00<'
    assert_false Xvm::XvmMessage.is_valid? '>RDB11 01 01;ID=1234;#8284;*43<' # wrong checksum
    assert_true Xvm::XvmMessage.is_valid? '>RGP010100000019+0000000+000000000000000FF1F0000;ID=1234;#827F;*53<'
    assert_true Xvm::XvmMessage.is_valid? '>GS_HD_ERASED;ID=1234;#2155;*0D<'
  end
end

