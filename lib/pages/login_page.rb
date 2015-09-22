class LoginPage
  include Capybara::DSL

  LOGIN_FIELD    = 'user_login'
  PASSWORD_FIELD = 'user_pass'
  LOGIN_BUTTON   = 'wp-submit'

  def initialize(driver)
    @driver = driver
  end

  def with(username, password)
    @driver.visit('/login')
    @driver.fill_in(LOGIN_FIELD, :with => username)
    @driver.fill_in(PASSWORD_FIELD, :with => password)
    @driver.click_on(LOGIN_BUTTON)
  end

  def check_page
    page.has_content?('Lost your password')
  end

  def verify_page
    page.has_content?('Email or Username')
  end

end