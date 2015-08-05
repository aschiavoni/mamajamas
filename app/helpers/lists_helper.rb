module ListsHelper
  def save_button_text(list)
    list.user.guest? ? "Save" : "Share"
  end
end
