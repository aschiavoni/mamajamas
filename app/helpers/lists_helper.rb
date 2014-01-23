module ListsHelper
  def save_button_text(list)
    list.saved? ? "Share" : "Save"
  end
end
