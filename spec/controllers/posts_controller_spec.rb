require 'spec_helper'

describe PostsController do

  context 'logged in' do

    before { session['user'] = mock_model(User, id: 2) }

    context 'index action' do

			it "Should return success on GET 'index'" do
				get 'index'
				response.should be_success
			end

			it "Should populate @posts with recent posts" do
				p = Post.create {|q| q.msg = "test"}
				get 'index'
				assigns(:posts).last.should == p
			end

      it "Should assume posts with parent_id==nil also posts" do
        p = Post.create {|q| q.parent_id = nil; q.msg = "nil parent"}
        get 'index'
        assigns(:posts).last.should == p
      end

      it "Should set @user with current user" do
        get 'index'
        expect(assigns :user).to eq session['user']
      end
		end

    context 'create action' do

      it "Should create a new user" do
        post 'create', msg: 'test'
        expect(Post.last.msg).to eq 'test'
        expect(Post.last.user_id).to eq 2
      end
    end
	end

  context 'logged out' do

    it "Should redirect to login" do
      get 'index'
			response.should redirect_to login_path
		end
	end
end
