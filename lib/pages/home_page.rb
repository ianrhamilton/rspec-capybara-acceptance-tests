class HomePage
  include Capybara::DSL

  NEW_POST = 'New Post'

  def initialize(driver)
    @driver = driver
    verify_page
  end

  def add_new_post
    @driver.click_on(NEW_POST)
  end

  private

  def verify_page
    page.has_content?('Followed Sites')
  end

end
