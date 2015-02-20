require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do

    visit root_path
    log_index = 0

    expect(page).to have_log_message('initializing', 0)

    click_button 'Next'

    expect(page.execute_script 'return SessionData().trials.length').to eq 14

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

    14.times do | trial_counter |
      trial = page.execute_script("return SessionData().trials[#{trial_counter}]")

      expect(page.execute_script("return SessionData().trial_counter")).to eq trial_counter
      expect(page).to have_selector('#fixating_point svg')

      presented_words = []

      10.times do | word_counter |

        expect(page.execute_script 'return SessionData().word_counter').to eq word_counter

        word = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}]")

        presented_words << word["text"]

        expect(page.find '#word').to be_visible
        expect(page.find '#word').to have_content word["text"]

        expect(word["delay"]).to eq 200 if word["color"]  == 'red'
        expect(word["delay"]).to eq trial["word_delay"] if word["color"] == 'blue'

        find('body').native.send_keys word["color"]  == 'blue' ? :arrow_right : :arrow_left

        # We have to wait until the next word appears, otherwise this E2E-Test will be to fast
        sleep (word["delay"].to_f / 1000)
      end

      if trial_counter == 13
        expect(page).to have_content 'This time please recall the blue words, not the red words, in their order of presentation. Continue by clicking on the blue circle.'

        page.execute_script("$(\"#blue_circle\").click()")
      else
        expect(page).to have_content 'Please select the 5 red words with the mouse'
      end

      presented_words.each do | word |
        page.execute_script("$(\"#retrieval_matrix div.ng-binding:contains('#{word}')\").click()")
      end

      if trial_counter == 1
        expect(page).to have_content 'When you are ready for the test trials, please press the right arrow key.'

        find('body').native.send_keys :arrow_left

        expect(page).to have_content 'Please press the right arrow key to continue ...'

        find('body').native.send_keys :arrow_right

        expect(page).to have_content 'When you are ready for the test trials, please press the right arrow key.'

        find('body').native.send_keys :arrow_right
      end
      sleep 2
    end

    choose 'Yes, my data should be used'

    fill_in 'age', with: '666'

    expect(page).to have_content 'Please provide a numerically age between 10 to 100'

    fill_in 'age', with: '22'

    expect(page).not_to have_content 'Please provide a numerically age between 10 to 100'

    choose 'Female'

    select 'high school degree', from: 'session_education'

    click_button 'Submit data ...'

    sleep 10

    expect(Session.count).to eq 1

    expect(page).to have_content 'Thank you again for participating in our experiment.'
  end
end
