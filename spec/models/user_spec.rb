require 'spec_helper'

describe User do
	
	# { 1 => "Saeed", 2 => "Amir", 3 => "Sadegh", 4 => "Hamed", 5 => "Pouria" }
	context "Primary values" do

		it "should have Saeed with the right id" do
			User.find_by_name("Saeed").id.should == 1
		end
		
		it "should have Saeed with the right id" do
			User.find_by_name("Amir").id.should == 2
		end
		
		it "should have Saeed with the right id" do
			User.find_by_name("Sadegh").id.should == 3
		end
		
		it "should have Saeed with the right id" do
			User.find_by_name("Hamed").id.should == 4
		end
		
		it "should have Saeed with the right id" do
			User.find_by_name("Pouria").id.should == 5
		end
	end

	context 'github' do
		it 'should return an Octokit client' do
			expect(User.first.github).to be_instance_of Octokit::Client
		end
	end
end
