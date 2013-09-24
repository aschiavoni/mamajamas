module Features
  module QuizHelpers
    def take_quiz
      click_link "start-quiz"
      expect(page).to have_content("Tell us a little bit about you")

      click_link "Start"
      expect(page).to have_content("mom/dad to be")
      # wait_until{ page.has_content?("dad to be") }

      click_link "Next"
      expect(page).to have_content("When it comes to feeding")

      click_link "Next"
      expect(page).to have_content("these types of diapers")

      click_link "Next"
      expect(page).to have_content("these sleeping arrangements")

      click_link "Next"
      expect(page).to have_content("comes to traveling")

      click_link "Next"
      expect(page).to have_content("comes to safety")

      click_link "Next"
      expect(page).to have_content("My zip code")

      click_link "Build My List"
      expect(page).to have_content("Your baby gear list")
      current_path.should == list_path
    end
  end
end
