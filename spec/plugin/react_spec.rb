require 'spec_helper'

RSpec.describe "React tags" do
  let(:filename) { 'test.jsx' }

  describe "anonymous fragments" do
    specify "editing the opening tag" do
      set_file_contents <<~HTML
        return (
          <>
            <td>Hello</td>
            <td>World</td>
          </>
        );
      HTML

      vim.search('<\zs>')
      edit('ifoobar')

      assert_file_contents <<~HTML
        return (
          <foobar>
            <td>Hello</td>
            <td>World</td>
          </foobar>
        );
      HTML
    end

    specify "editing the closing tag" do
      set_file_contents <<~HTML
        return (
          <>
            <td>Hello</td>
            <td>World</td>
          </>
        );
      HTML

      vim.search('<\/\zs>')
      edit('ibarbaz')

      assert_file_contents <<~HTML
        return (
          <barbaz>
            <td>Hello</td>
            <td>World</td>
          </barbaz>
        );
      HTML
    end

    specify "deletion" do
      set_file_contents <<~HTML
        return (
          <React.Fragment>
            <td>Hello</td>
            <td>World</td>
          </React.Fragment>
        );
      HTML

      vim.search('<\zsReact\.')
      edit('di>')

      assert_file_contents <<~HTML
        return (
          <>
            <td>Hello</td>
            <td>World</td>
          </>
        );
      HTML
    end
  end
end
