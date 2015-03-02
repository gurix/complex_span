RSpec::Matchers.define :have_log_message do |message, index|
  match do |page|
    expect(page.execute_script("return logger.log").last['message']).to eq message
  end
end
