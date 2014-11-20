require 'rails_helper'

describe 'Experiment', js: true do
  scenario 'running the complete process' do
    visit root_path(locale: I18n.default_locale)

    expect(page.execute_script 'return logger.log[0].message').to eq 'initializing'

    click_button 'Next'

    expect(page.execute_script 'return logger.log[1].message').to eq 'toggleFullScreen'

    fill_in 'age', with: '666'

    expect(page).to have_content 'Please provide a numerically age between 10 to 100'

    fill_in 'age', with: '22'

    expect(page).not_to have_content 'Please provide a numerically age between 10 to 100'

    choose 'Female'

    select 'high school degree', from: 'session_education'

    click_button 'Next'

    expect(page.execute_script 'return logger.log[2].message').to eq 'startSession'
  end
end
