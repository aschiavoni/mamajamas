module Features
  module ListHelpers
    def add_manual_item(name, link)
      # I don't like these sleeps but I can't get this to work under
      # poltergeist any other way
      click_link "Choose"
      sleep_maybe
      page.should have_selector("#search-modal", visible: true)
      sleep_maybe
      find("#add-your-own-collapsible").click
      sleep_maybe
      page.should have_selector("#frm-addown", visible: true)
      fill_in "field-prodname", with: name
      sleep_maybe
      click_link "Add"
      sleep_maybe
      page.should have_selector(".new-list-item", visible: true)
      fill_in "list_item[link]", with: link
      sleep_maybe
      click_button "Save"
      page.should have_content(name)
      sleep_maybe
    end

    def sleep_maybe
      t = ENV['MAMAJAMAS_FEATURE_SLEEP'] || "1.6"
      sleep t.to_f
    end
  end
end
