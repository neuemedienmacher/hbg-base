# using redcarpet
class MarkdownRenderer
  def self.render markdown_string
    return nil if markdown_string.nil?
    setup_markdown.render markdown_string
  end

  private

  def self.setup_markdown
    options = {
      link_attributes: {
        target: '_blank'
      },
      hard_wrap: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    Redcarpet::Markdown.new(renderer, {})
  end
end
