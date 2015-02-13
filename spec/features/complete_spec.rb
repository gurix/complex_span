require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do
    visit root_path

    expect(page.execute_script 'return logger.getMessage(0)').to eq 'initializing'

    expect(page.execute_script 'return SessionData().trials.length').to eq 14

    click_button 'Next'

    expect(page.execute_script 'return logger.getMessage(1)').to eq 'toggleFullScreen'
    expect(page.execute_script 'return logger.getMessage(2)').to eq 'Show instruction 1'
    expect(page).to have_content 'Please press the right arrow key to continue'

    find("body").native.send_keys :arrow_right

    expect(page.execute_script 'return logger.getMessage(3)').to eq 'Show instruction 1_1'
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'


    find("body").native.send_keys :arrow_left

    expect(page.execute_script 'return logger.getMessage(4)').to eq 'Show instruction 1'
    expect(page).to have_content 'Please press the right arrow key to continue'

    find("body").native.send_keys :arrow_right

    expect(page.execute_script 'return logger.getMessage(5)').to eq 'Show instruction 1_1'
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

    expect(page.execute_script 'return logger.getMessage(5)').to eq 'Show instruction 1_1'

    find("body").native.send_keys :arrow_right

    14.times do | trial_counter |
      expect(page.execute_script 'return SessionData().trial_counter').to eq (trial_counter)
      expect(page).to have_selector('#fixating_point svg')
      10.times do | word_counter |

        expect(page.execute_script 'return SessionData().word_counter').to eq (word_counter)

        word_text = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].text")

        expect(page).to have_content word_text
        binding.pry
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
