# Configure RubyLLM with your AI provider(s).
# You only need keys for providers you plan to use.
# See https://rubyllm.com for full configuration options.
RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]
end

QueryLens.configure do |config|
  config.model = "claude-sonnet-4-5-20250929"
  config.authentication = ->(controller) { true }
end
