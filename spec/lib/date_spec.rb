require "spec_helper"
require "our_date"

describe Date do
	subject {Date.last_thursday}
	
	it "should not return nil when one calls last_thursday" do
		expect(subject).not_to be_nil
	end

	it "should be in past" do
		expect(subject).to be_past
	end

	it "should be thursday" do
		expect(subject).to be_thursday
	end
end
