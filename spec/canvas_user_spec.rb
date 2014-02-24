require 'spec_helper'

describe Canvas::User do

  it 'should load a single user' do
    VCR.use_cassette 'test_request_user_search' do
      user = Canvas::User.find '1'
      user.id.must_equal 1
      user.name.must_equal 'Billy Bob'
      user.sortable_name.must_equal 'Bob, Billy'
      user.short_name.must_equal 'Billy Bob'
      user.login_id.must_equal 'david@gorges.us'
    end
  end
  
  it 'should save a single user' do
    user = nil
    VCR.use_cassette 'test_request_user_search' do
      user = Canvas::User.find 1
    end
    VCR.use_cassette 'test_change_name_to_daryl' do
      user.name = 'Daryl'
      user.save.must_equal true
    end
    user.name.must_equal 'Daryl'
  end
  
  it 'should create a new user' do
    VCR.use_cassette('test_request_post') do
      user = Canvas::User.new
      user.attributes = {
        name: 'Bob Martin',
        sis_user_id: '2',
        email: 'bob@martin.edu'
      }
      user.save
      user.persisted?.must_equal true
      user.id.must_equal 2
    end
  end
  
  it 'should delete an existing user' do
    VCR.use_cassette('test_request_delete') do
      user = Canvas::User.new id: 2
      user.destroy.must_equal true
      user.frozen?.must_equal true
    end      
  end
  
end