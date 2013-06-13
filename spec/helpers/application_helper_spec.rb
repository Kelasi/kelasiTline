require 'spec_helper'

describe ApplicationHelper do

  context "titleize" do

    it "Should return blank on blank string" do
      titleize(" \t").should be_blank
    end

    it "Should add a | in front of a non-blank string" do
      titleize("salam").should == " | salam"
    end
  end
end
