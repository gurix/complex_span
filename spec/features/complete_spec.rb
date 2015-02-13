require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do
    visit root_path

    expect(page.execute_script 'return logger.getMessage(0)').to eq 'initializing'

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


    # expect(page.execute_script 'return logger.log[1].message').to eq 'toggleFullScreen'
    #
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
