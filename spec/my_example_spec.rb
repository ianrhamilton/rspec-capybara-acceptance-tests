require 'rspec'
require_relative '../spec/support/spec_helper'

describe 'Wordpress Authentication example 1' do
  context 'Login is optional' do

    it 'should show I am logged in when I am logged in' do
      @site.login_page.with('info@rubygemtsl.co.uk', 'P@$$word01')
      @site.home_page.add_new_post
    end

    it 'should not show I am logged in when I am not logged in' do
      @site.login_page.with('info@rubygemtsl.co.uk', 'fail')
      sleep(3)
      @site.login_page.check_page
    end

  end
end
