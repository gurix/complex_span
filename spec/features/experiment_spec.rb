require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do
    visit root_path
    page.execute_script('localStorage.clear()')

    expect(page).to have_log_message('initializing')

    expect(page).to have_content 'If you agree, please press the “Next” button below.'

    click_button 'Next'

    expect(page).to have_log_message('Push data')

    expect(page).to have_content 'To run this experiment we need to take you in fullscreen mode.'

    session = Session.last

    expect(Session.count).to eq 1
    expect(session.ip_address).to eq '127.0.0.1'

    expect(session.language).to eq 'en'
    expect(session.created_at).to_not be_nil
    expect(session.trials).to be_empty
    expect(session.logs).not_to be_empty

    click_button 'Next'

    expect(page.execute_script 'return SessionData().trials.length').to eq 14

    expect(page).to have_log_message('Show instruction 1')

    expect(page).to have_content 'Please press the right arrow key to continue'

    find('body').native.send_keys :arrow_right

    expect(page).to have_log_message('Show instruction 1_1')
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

    find('body').native.send_keys :arrow_left

    expect(page).to have_log_message('Show instruction 1')
    expect(page).to have_content 'Please press the right arrow key to continue'

    find('body').native.send_keys :arrow_right

    expect(page).to have_log_message('Show instruction 1_1')
    expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

    find('body').native.send_keys :arrow_right

    15.times do |artificial_trial_counter|
      # For each trial we randomly miss one wird
      missing_decision = (0..9).to_a.sample

      # Get the trial counter from the running app
      trial_counter = page.execute_script('return SessionData().trial_counter')

      # There is a shift because we force trial 2 to repeat with no decission > 70%
      if artificial_trial_counter < 3
        expect(trial_counter).to eq artificial_trial_counter
      else
        expect(trial_counter + 1).to eq artificial_trial_counter
      end

      trial = page.execute_script("return SessionData().trials[#{trial_counter}]")

      expect(page).to have_selector('#fixating_point svg')

      presented_words = []

      10.times do | word_counter |
        expect(page.execute_script 'return SessionData().word_counter').to eq word_counter

        word = page.execute_script("return SessionData().trials[#{trial_counter}].words[#{word_counter}]")

        presented_words << word['text']

        expect(page.find '#word').to be_visible
        Capybara.exact = true
        expect(page.find '#word').to have_content word['text']
        Capybara.exact = false

        expect(word['delay']).to eq 200 if word['color']  == 'red'
        expect(word['delay']).to eq trial['word_delay'] if word['color'] == 'blue'

        if missing_decision == word_counter
          decision_warning = 'Attention: Please make a size judgment!'
          # Check whether a warning was displayed if we do not take a decision for word 5 in the first trial within 3 seconds
          sleep 2.5
          if trial_counter < 2
            expect(page).to have_content decision_warning
            sleep 3
          else
            expect(page).not_to have_content decision_warning
          end
        else
          sleep(0.3) # Wait at least 300ms to be sure not to be to fast
          # Send the correct key for all trials except 2, there we change everything
          if artificial_trial_counter != 2
            find('body').native.send_keys word['size_difference'].to_i > 0 ? :arrow_right : :arrow_left
          else
            find('body').native.send_keys word['size_difference'].to_i < 0 ? :arrow_right : :arrow_left
          end
        end

        # We have to wait until the next word appears, otherwise this E2E-Test will be to fast
        sleep(0.3 + (word['delay'].to_f / 1000))
      end

      if trial_counter == 13
        expect(page).to have_content 'This time please recall the blue words, not the red words, in their order of presentation.'
        expect(page).to have_content 'Continue by clicking on the blue circle.'

        page.execute_script("$(\"#blue_circle\").click()")
      else
        expect(page).to have_content 'Please select the 5 red words, in their order of presentation, with the mouse'
      end

      presented_words.sample(5).each_with_index do | word, index |
        sleep(0.3) # Wait at least 300ms to be sure not to be to fast
        page.execute_script("$(\"#retrieval_matrix div.ng-binding\").filter(function(index) { return $(this).text() === \"#{word}\"; }).click()")

        expect(page.execute_script("return SessionData().trials[#{trial_counter}].retrieval_clicks[#{index}].text")).to eq word
      end

      if trial_counter == 1
        sleep(0.3) # Wait at least 300ms to be sure not to be to fast
        expect(page).to have_content 'When you are ready for the serious trials, please press the right arrow key.'

        find('body').native.send_keys :arrow_left

        expect(page).to have_content 'Please press the right arrow key to continue ...'

        find('body').native.send_keys :arrow_right

        expect(page).to have_content 'When you are ready for the serious trials, please press the right arrow key.'

        find('body').native.send_keys :arrow_right
      end

      expect(page.execute_script("return SessionData().trials[#{trial_counter}].started_at").to_time).to be <= Time.now
      expect(page.execute_script("return SessionData().trials[#{trial_counter}].retrieval_matrix_shown_at").to_time).to be <= Time.now

      expect(page).to have_content 'Too many incorrect size judgments, trial will be repeated.'  if artificial_trial_counter == 2

      repeated = page.execute_script("return SessionData().trials[#{trial_counter}].repeated")
      expect(repeated).to eq trial_counter == 2 ? true : false
    end

    choose 'Yes, my data should be used'

    fill_in 'age', with: '666'

    expect(page).to have_content 'Please provide a numerically age between 10 to 100'

    fill_in 'age', with: '22'

    expect(page).not_to have_content 'Please provide a numerically age between 10 to 100'

    choose 'Male'
    choose 'Others'
    choose 'Female'

    select 'high school degree', from: 'session_education'

    click_button 'Submit data ...'

    sleep 4

    expect(Session.count).to eq 1
    session.reload

    expect(session.updated_at).to_not be_nil
    expect(session.trials.count).to eq 14
    expect(session.age).to eq 22
    expect(session.sincerity).to eq 'serious'
    expect(session.gender).to eq 'f'
    expect(session.education).to eq 'high_school'

    expect(page).to have_content 'Thank you again for participating in our experiment.'

    page.execute_script('localStorage.clear()')
  end

  context 'navigation during tests' do
    before do
      visit root_path
      page.execute_script('localStorage.clear()')

      expect(page).to have_content 'If you agree, please press the “Next” button below.'

      click_button 'Next'

      expect(page).to have_content 'To run this experiment we need to take you in fullscreen mode.'

      click_button 'Next'

      expect(page).to have_content 'Please press the right arrow key to continue'

      find('body').native.send_keys :arrow_right

      expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

      find('body').native.send_keys :arrow_left

      expect(page).to have_content 'Please press the right arrow key to continue'

      find('body').native.send_keys :arrow_right

      expect(page).to have_content 'When you are ready for the practice trials, please press the right arrow key.'

      find('body').native.send_keys :arrow_right

      expect(page.find '#word').to be_visible
    end

    scenario 'user reloads the page during the test' do
      page.driver.browser.navigate.refresh

      expect(page).to have_content 'The experiment was aborted because you exited or reloaded the page.'

      page.execute_script('localStorage.clear()')
    end

    scenario 'user hits the back button during the test' do
      page.driver.browser.navigate.back

      expect(page).to have_content 'The experiment was aborted because you exited or reloaded the page.'

      page.execute_script('localStorage.clear()')
    end
  end
end
