require 'spec_helper'

describe 'login routes' do
  
  it 'Should redirect to /login' do
    get '/'
    response.should redirect_to '/login'
  end
end
