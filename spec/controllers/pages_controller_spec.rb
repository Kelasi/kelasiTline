require 'spec_helper'

describe PagesController do

  describe "GET 'timeline'" do
    it "returns http success" do
      get 'timeline'
      response.should be_success
    end
  end

  context "login page" do

  	it "Should return success" do
  		get 'login'
  		response.should be_success
  	end

  	it "Should login on post" do
  		post 'do_login'
  		response.should redirect_to root_path
  	end

  	it "Should login as right user" do
  		post 'do_login', name: 'Saeed'
  		session['user'].name.should == 'Saeed'
  	end
  end

  context 'logout' do
    
    it 'should logout on GET /logout' do
      get 'logout'
      should_not be_logged_in
    end

    it 'should redirect to /' do
      get 'logout'
      response.should redirect_to root_path
    end
  end
end
