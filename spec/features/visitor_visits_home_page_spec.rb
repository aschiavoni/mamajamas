require 'spec_helper'

feature "Visitor visits home page" do

  scenario "guest visits home page" do
    visit root_path
    expect(page).to have_content("Mamajamas")
  end

end
