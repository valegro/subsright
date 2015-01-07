require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save a configuration without a key" do
    configuration = Configuration.new
    assert_raises(ActiveRecord::StatementInvalid) { configuration.save }
  end
  test "should not save a configuration without a form_type" do
    configuration = Configuration.new( key: 'Test' )
    assert_raises(ActiveRecord::StatementInvalid) { configuration.save }
  end
  test "should save a configuration with a valid key and form_type" do
    configuration = Configuration.new( key: 'Test', form_type: :string )
    assert configuration.save
  end
end
