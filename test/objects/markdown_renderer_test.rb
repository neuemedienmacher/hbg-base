require_relative '../test_helper'

class MarkdownRendererTest
  describe '#self.render' do
    it 'should add html tags to a given text' do
      MarkdownRenderer.render('foobar').must_match '<p>foobar</p>'
      MarkdownRenderer.render('**foobar**')
                      .must_match'<p><strong>foobar</strong></p>'
    end
  end
end
