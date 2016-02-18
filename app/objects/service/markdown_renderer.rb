# using redcarpet
class MarkdownRenderer
  RENDERER_OPTIONS = {
    link_attributes: {
      target: '_blank'
    },
    hard_wrap: true
  }.freeze
  MARKDOWN_OPTIONS = {}.freeze

  @renderer = Redcarpet::Render::HTML.new RENDERER_OPTIONS
  @markdown = Redcarpet::Markdown.new(@renderer, MARKDOWN_OPTIONS)

  def self.render markdown_string
    return nil if markdown_string.nil?
    @markdown.render markdown_string
  end
end
