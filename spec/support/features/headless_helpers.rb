module Features
  module HeadlessHelpers
    def save_and_open_page
      sleep 1
      dir = "#{Rails.root}/tmp/cache/capybara"
      file = "#{dir}/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png"
      FileUtils.mkdir_p dir
      page.driver.render file
      wait_until { File.exists?(file) }
      system "open #{file}"
    end
    alias_method :page!, :save_and_open_page
  end
end
