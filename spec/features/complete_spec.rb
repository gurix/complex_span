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

    14.times do | trial_counter |

      expect(page.execute_script 'return SessionData().trial_counter').to eq trial_counter
      expect(page).to have_selector('#fixating_point svg')

      word_delay_condition = page.execute_script("return SessionData().trials[#{trial_counter}].word_delay")

      presented_words = []

      10.times do | word_counter |

        expect(page.execute_script 'return SessionData().word_counter').to eq word_counter

        word_text = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].text")
        presented_words << word_text

        word_color = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].color")
        word_delay = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}].delay")

        expect(page.find '#word').to be_visible
        expect(page.find '#word').to have_content word_text

        expect(word_delay).to eq 200 if word_color == 'red'
        expect(word_delay).to eq word_delay_condition if word_color == 'blue'

        find('body').native.send_keys word_color == 'blue' ? :arrow_right : :arrow_left

        # We have to wait until the next word appears, otherwise this E2E-Test will be to fast
        sleep (word_delay.to_f / 1000)
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

    choose 'I did the test not seriously'

    fill_in 'age', with: '666'

    expect(page).to have_content 'Please provide a numerically age between 10 to 100'

    fill_in 'age', with: '22'

    expect(page).not_to have_content 'Please provide a numerically age between 10 to 100'

    choose 'Female'

    select 'high school degree', from: 'session_education'

    click_button 'Submit data ...'

  end
end
