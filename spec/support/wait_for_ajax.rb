module WaitForAjax
  def wait_for_ajax
    sleep(1)
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
