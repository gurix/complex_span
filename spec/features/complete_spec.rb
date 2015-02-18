require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do
    visit root_path
    log_index = 0

    expect(page).to have_log_message('initializing', 0)

    expect(page.execute_script 'return SessionData().trials.length').to eq 14

    click_button 'Next'

    expect(page).to have_log_message('toggleFullScreen', log_index += 1)
    expect(page).to have_log_message('Show instruction 1', log_index += 1)

    expect(page).to have_content 'Please press the right arrow key to continue'

    find('body').native.send_keys :arrow_right

    expect(page).to have_log_message('Show instruction 1_1', log_index += 1)
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

    find('body').native.send_keys :arrow_left

    expect(page).to have_log_message('Show instruction 1', log_index += 1)
    expect(page).to have_content 'Please press the right arrow key to continue'

    find('body').native.send_keys :arrow_right

    expect(page).to have_log_message('Show instruction 1_1', log_index += 1)
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

    find('body').native.send_keys :arrow_right

    # In trial mode we test some possible answers

    14.times do | trial_counter |
      expect(page.execute_script 'return SessionData().trial_counter').to eq trial_counter
      expect(page).to have_selector('#fixating_point svg')
      10.times do | word_counter |
        expect(page.execute_script 'return SessionData().word_counter').to eq word_counter

        word_text = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].text")
        word_color = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].color")

        expect(page).to have_content word_text

        find('body').native.send_keys word_color == 1 ? :arrow_right : :arrow_left
      end
    end

    # fill_in 'age', with: '666'
    #
    # expect(page).to have_content 'Please provide a numerically age between 10 to 100'
    #
    # fill_in 'age', with: '22'
    #
    # expect(page).not_to have_content 'Please provide a numerically age between 10 to 100'
    #
    # choose 'Female'
    #
    # select 'high school degree', from: 'session_education'
    #
    # click_button 'Next'
    #
    # expect(page.execute_script 'return logger.log[2].message').to eq 'startSession'
  end
end
