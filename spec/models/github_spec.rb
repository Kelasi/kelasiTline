require "spec_helper"

describe Github do

	it "should successfully authenticate using an environmental variable" do
		Github.login
		expect(Github.login?).to be_true
	end

	context "issues" do

		it "should return kelasiTline issues successfully" do
			response = Github.issues('kelasiTline')
			response.detect { |res| res[:id] }
		end

		it "should return kelasi issues successfully" do
			response = Github.issues('kelasi')
			response.detect { |res| res[:id] }
		end

		it "should be authenticated when requesting issues" do
			response = Github.issues('kelasiTline')
			expect(Github.login?).to be_true
		end
	end

	context "token" do
		it "should return appropriate token based on require user" do
			response = Github.token('Amir')
			expect(response).to eq ENV['AMIR_GITHUB_TOKEN']
		end
	end
end
