require 'rails_helper'

describe 'Languages', js: true do
  scenario 'use english if no language is given' do
    visit root_path

    page.execute_script('localStorage.clear()')

    expect(page).to have_content 'If you agree, please press the “Next” button below.'
  end

  scenario 'navigating directly to english' do
    visit "#{root_path}#/en"

    page.execute_script('localStorage.clear()')

    expect(page).to have_content 'If you agree, please press the “Next” button below.'
  end

  scenario 'navigating directly to german' do
    visit "#{root_path}#/de"

    page.execute_script('localStorage.clear()')

    expect(page).to have_content 'Wenn Sie einverstanden sind, an dem Experiment teilzunehmen, drücken Sie bitte unten die Taste „Weiter“'
    page.execute_script('localStorage.clear()')
  end

  scenario 'switch language via button' do
    visit root_path

    page.execute_script('localStorage.clear()')

    expect(page).to have_content 'If you agree, please press the “Next” button below.'

    click_button 'Deutsch'

    expect(page).to have_content 'Wenn Sie einverstanden sind, an dem Experiment teilzunehmen, drücken Sie bitte unten die Taste „Weiter“'

    click_button 'English'

    expect(page).to have_content 'If you agree, please press the “Next” button below.'
  end
end
