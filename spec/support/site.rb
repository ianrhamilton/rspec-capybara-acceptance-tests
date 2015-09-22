class Site

  def initialize(driver)
    @driver = Capybara.current_session
  end

  def login_page
    @login_page ||= LoginPage.new(@driver)
  end

  def home_page
    @home_page ||= HomePage.new(@driver)
  end

end
