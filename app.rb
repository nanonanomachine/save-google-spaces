require "bundler/setup"
Bundler.require

# Google account
EMAIL = 'Change your email'
PASSWORD = 'Change your password'

# Login UI
# It may change in your language
BUTTON_NEXT = 'Next'
FILL_IN_PASSWORD = 'Password'
BUTTON_LOGIN = 'Login'

directory_name = ARGV[0]

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome )
end

session = Capybara::Session.new(:selenium)
#␣Go␣to␣Spaces␣landing␣page↲
session.visit "https://spaces.google.com"
session.click_link "Go to spaces"

#␣Login↲
session.fill_in 'Email', with: EMAIL
session.click_button BUTTON_NEXT
session.fill_in FILL_IN_PASSWORD, with: PASSWORD
session.click_button BUTTON_LOGIN

#␣Get␣All␣Spaces↲
space_urls = Array.new
space_directory_names = Array.new

session.all('.kX5sNb').each do |space|
  space_directory_name = File.join(directory_name, space.text)
  space_directory_names << space_directory_name
  Dir.mkdir(space_directory_name) unless File.exists?(space_directory_name)

  space_urls << space[:href]
end

space_urls.each_with_index do |space_url, i|
  session.visit space_url

  topic_urls = Array.new
  session.all('c-wiz .c1tmJe').each do |topic|
    iid = topic['data-iid']
    topic_urls << space_url + "/post/#{iid}"
  end

  topic_urls.each_with_index do |topic_url, j|
    session.visit topic_url

    # Force append old comments
    30.times.each do
      session.execute_script "var divs = document.getElementsByClassName('S0zjke eejsDc');divs[divs.length -1].scrollTop = 0;"
      # Changing window size enables trigger xhr
      session.driver.browser.manage.window.resize_to(800, 100)
      session.driver.browser.manage.window.maximize
    end

    File.open(File.join(space_directory_names[i], "#{j}.text"), 'a') do |f|
      session.all('div.iTFkL').each do |comment|
        if comment.has_css?('a')
          comment.all('a').each do |link|
            f.puts link[:href]
          end
        elsif comment.has_css?('.li9sW')
          f.puts comment.find('.li9sW').text
        end
      end
    end
  end
end
