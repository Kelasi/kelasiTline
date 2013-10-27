require 'spec_helper'

describe GithubsController do

	context "index" do
		it "should returns issues from github repos" do
			get 'index', format: :json, repo: "kelasiTline"
			expect(response).to be_success
		end
	end
end
