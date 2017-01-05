# using redcarpet
class MarkdownRenderer
  # Quite, Rubocop! (Redcarpet error with frozen hashes)
  # rubocop:disable Style/MutableConstant
  RENDERER_OPTIONS = {
    link_attributes: {
      target: '_blank'
    },
    hard_wrap: true
  }
  MARKDOWN_OPTIONS = {}
  # rubocop:enable Style/MutableConstant

  @renderer = Redcarpet::Render::HTML.new RENDERER_OPTIONS
  @markdown = Redcarpet::Markdown.new(@renderer, MARKDOWN_OPTIONS)

  def self.render markdown_string
    return nil if markdown_string.nil?
    @markdown.render markdown_string
  end
end
