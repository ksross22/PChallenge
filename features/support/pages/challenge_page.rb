class ChallengePage
  #Using libraries
  include PageObject
  include DataMagic

  #starting URL
  page_url("http://www.google.com")

  #page object web elements used in the challenge
  a(:sign_in, :id => 'gb_70')
  text_field(:email, :id => 'Email')
  button(:next_button, :id => 'next')
  text_field(:password, :id => 'Passwd')
  button(:signin_button, :id => 'signIn')

  text_field(:search_box, :id => 'lst-ib')
  button(:search_button, :name => 'btnK')
  a(:shopping_tab, :link_text => 'Shopping')
  div(:results_bar, :id => 'topabar')
  #shopping section elements
  div(:shopping_section, :class => 'sh-sr__shop-result-group')
  div(:view_wrapper, :id => 'stt__ps-view')
  div(:list_option, :id => ':d')
  div(:grid_option, :id => ':c')

  #list elements
  div(:list_item, :class => 'psli')
  div(:grid_item, :class => 'psgi')

  #detail items
  div(:short_list_button, :class => 'gko-add')
  div(:short_list_bubble, :css => 'div.jfk-bubble.gko-c')
  text_area(:add_note_text, :class => 'gko-c-ni')

  def sign_in_to_google
    sign_in_element.when_visible.click

    DataMagic.yml_directory = 'config/data'
    DataMagic.load 'default.yml'

    login_data = data_for :google_login
    self.email = login_data['email']
    next_button
    sleep 1
    self.password = login_data['password']
    signin_button
  end

  def search_google(text)
    search_box_element.when_visible
    self.search_box = text

    search_box_element.send_keys :enter
    results_bar_element.when_visible
  end

  def navigate_tabs(tab)
    nav_tab = @browser.find_element(:link_text => "#{tab}")
    nav_tab.click
    shopping_section_element.when_visible

  end

  def find_result_by_number(num)
    n_index = num.to_i-1
    sleep 2
    result = @browser.find_element(:xpath => "//*[@id='rso']/div[1]/div/div[#{num.to_i}]")
    result.click
  end

  def save_to_short_list
    short_list_button_element.when_visible.click
    sleep 3
    short_list_bubble_element.when_visible
  end

  def saved_actions(action)
    if action == "Add note"
      bubble = @browser.find_element(:class => 'gko-c-s')
      bubble.find_element(:class => '_-b').click
    end
  end

  def note_text(text)
    bubble = @browser.find_element(:class => "gko-c-s")
    bubble.find_element(:class => 'gko-c-ni').send_keys text
  end


end