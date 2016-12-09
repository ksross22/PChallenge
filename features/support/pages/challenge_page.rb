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
  div(:clear_shortlist, :class => 'gko-ctrl-c')

  #list elements
  div(:list_item, :class => 'psli')
  div(:grid_item, :class => 'psgi')

  #detail items
  div(:short_list_button, :class => 'gko-add')
  div(:short_list_bubble, :css => 'div.jfk-bubble.gko-c')
  text_area(:add_note_text, :class => 'gko-c-ni')
  span(:saved_note_text, :class => 'jNm5if')
  div(:shortlist_page, :class => 'l4eHX-iJ4yB')

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
    name_of_item = @browser.find_element(:class => 'sh-t__title').text
    $name_of_item = name_of_item.gsub!(/[^0-9A-Za-z]/, "")
  end

  def save_to_short_list
    short_list_button_element.when_visible.click
    sleep 3
    short_list_bubble_element.when_visible
    bubble = @browser.find_element(:class => 'gko-c-s')

    fail unless bubble.find_element(:class => '_-j').text.include? "Saved to your default Shortlist"
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
    bubble.find_element(:class => 'jfk-button-action').click
  end

  def verify_note_saved
    sleep 5
    bubble = @browser.find_element(:class => 'gko-c-n')

    fail unless bubble.find_element(:class => '_-j').text.include? "Note saved for"
    text_of_verify = bubble.find_element(:class => '_-k').text
    text_of_verify = text_of_verify.gsub!(/[^0-9A-Za-z]/, "")

    fail unless text_of_verify == $name_of_item
  end

  def review_note(text)
    sleep 2

    bubble = @browser.find_element(:class => 'gko-c-n')
    bubble.find_element(:class => '_-b').click


    shortlist_page_element.when_visible
    saved_note_text_element.text.include? text

  end

  def reset_shortlist
    @browser.navigate.back
    shopping_section_element.when_visible
    sleep 1
    clear_shortlist_element.click
    sleep 1

    clear_popup = @browser.find_element(:class => 'gko-ccd')
    clear_popup.find_element(:name => 'ok').click
  end


end