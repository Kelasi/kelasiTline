require 'spec_helper'


feature "titleize" do

  scenario "pages/ng should have the right title" do
    visit '/ng'
    expect(page).to have_title '| ng'
  end
end
