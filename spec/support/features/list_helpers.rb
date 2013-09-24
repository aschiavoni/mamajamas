module Features
  module ListHelpers
    def add_manual_item(name, link)
      # I don't like these sleeps but I can't get this to work under
      # poltergeist any other way
      click_link "Choose"
      page.should have_selector("#search-modal", visible: true)
      sleep 0.5
      find("#add-your-own-collapsible").click
      page.should have_selector("#frm-addown", visible: true)
      fill_in "field-prodname", with: name
      click_link "Add"
      page.should have_selector(".new-list-item", visible: true)
      fill_in "list_item[link]", with: link
      click_button "Save"
      page.should have_content(name)
      sleep 0.5
    end
  end
end
