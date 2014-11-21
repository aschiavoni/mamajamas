module Features
  module QuizHelpers
    def take_quiz
      click_link "Create your registry"
      expect(page).to have_content("Tell us a little bit about you")

      click_link "Start"
      expect(page).to have_content("am expecting")

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
      sleep 1
      expect(page).to have_content("Suggest products")

      click_link "Next"
      expect(page).to have_content("My zip code")

      click_link "Build My Registry"
      expect(page).to have_content("Your baby gear registry")
      expect(current_path).to eq(list_path)
    end
  end
end
