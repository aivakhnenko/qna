module ApiHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options = {})
    options[:headers] ||= { 'ACCEPT' => 'application/json' }
    send method, path, options
  end
end
