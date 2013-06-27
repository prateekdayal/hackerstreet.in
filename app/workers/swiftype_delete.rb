class SwiftypeDelete
  include Sidekiq::Worker

  def perform(id)
    client = Swiftype::Easy.new
    client.destroy_document(ENV['SWIFTYPE_ENGINE_SLUG'], Story.model_name.downcase, id)
  end
end