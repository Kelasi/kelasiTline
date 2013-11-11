require 'spec_helper'

describe GithubsController do

	context "index" do
		it "should returns issues from github repos" do
			get :index, format: :json, repo: "kelasiTline"
			expect(response).to be_success
		end
	end

	context "create" do
		it "should redirect to login_path when user is not logged in" do
			post :create, repo: "saeedSarpas/kelasiTlineTDDhelper",
						  title: Time.now,
						  body: Time.now
			response.should redirect_to(login_path)
		end

		it "should successfully call Github model create_issue method" do
			session['user'] = User.first
			repo  = "saeedSarpas/kelasiTlineTDDhelper"
			title = Time.now
			body  = Time.now
			post :create, repo: repo, title: title, body: body
			expect(Github.issues(repo).first.title).to eq title.to_s
		end
	end
end
