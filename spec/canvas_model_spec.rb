require 'spec_helper'

describe Canvas::Model do

  it 'should know its client as class method' do
    Canvas::Model.client.is_a?(Canvas::Client).must_equal true
  end
  
  it 'should know its client as instance method' do
    model = Canvas::Model.new
    model.client.is_a?(Canvas::Client).must_equal true
  end
  
  it 'should know when it is a new record' do
    model = Canvas::Model.new
    model.new_record?.must_equal true
    model.persisted?.must_equal false
  end
  
  it 'should know when it is persisted' do
    model = Canvas::Model.new id: 2
    model.new_record?.must_equal false
    model.persisted?.must_equal true
  end
  
end