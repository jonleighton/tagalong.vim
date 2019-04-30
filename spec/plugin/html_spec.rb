require 'spec_helper'

RSpec.describe "HTML" do
  let(:filename) { 'test.html' }

  specify "changing a simple multiline tag" do
    set_file_contents <<~HTML
      <div>
        <span>Text</span>
      </div>
    HTML

    vim.search('div')
    edit('cwarticle')

    assert_file_contents <<~HTML
      <article>
        <span>Text</span>
      </article>
    HTML
  end

  specify "changing a simple single-line tag" do
    set_file_contents <<~HTML
      <div><span>Text</span></div>
    HTML

    vim.search('div')
    edit('cwarticle')

    assert_file_contents <<~HTML
      <article><span>Text</span></article>
    HTML

    vim.search('span')
    edit('cwa')

    assert_file_contents <<~HTML
      <article><a>Text</a></article>
    HTML
  end

  specify "keeping and adding attributes" do
    set_file_contents <<~HTML
      <div class="example">
        <span>Text</span>
      </div>
    HTML

    vim.search('div')
    edit('cwarticle')

    assert_file_contents <<~HTML
      <article class="example">
        <span>Text</span>
      </article>
    HTML

    vim.search('span')
    edit('cwa href="http://test.host"')

    assert_file_contents <<~HTML
      <article class="example">
        <a href="http://test.host">Text</a>
      </article>
    HTML
  end

  specify "invalid tag changes" do
    set_file_contents <<~HTML
      <div class="example">
        <span>Text</span>
      </div>
    HTML

    vim.search('div')
    edit('cw')

    assert_file_contents <<~HTML
      < class="example">
        <span>Text</span>
      </div>
    HTML

    vim.search('span')
    edit('cw')

    assert_file_contents <<~HTML
      < class="example">
        <>Text</span>
      </div>
    HTML
  end

  specify "changing closing tag" do
    set_file_contents <<~HTML
      <div class="example">
        <span>Text</span>
      </div>
    HTML

    vim.search('<\/\zsdiv')
    edit('cwarticle')

    assert_file_contents <<~HTML
      <article class="example">
        <span>Text</span>
      </article>
    HTML
  end

  specify "changing ul surrounding li (bug)" do
    set_file_contents <<~HTML
      <ul class="name">
        <span class="one">One</span>
        <span class="two">Two</span>
        <span class="three">Three</span>
      </ul>
    HTML

    vim.search('span class="one"')
    edit('cwli')
    vim.search('ul class="name"')
    edit('cwli')

    assert_file_contents <<~HTML
      <li class="name">
        <li class="one">One</li>
        <span class="two">Two</span>
        <span class="three">Three</span>
      </li>
    HTML
  end

  specify "self-closing tags" do
    set_file_contents <<~HTML
      <div class="one">
        <div class="two">
          <br />
        </div>
      </div>
    HTML

    vim.search('div class="one"')
    edit('cwspan')

    assert_file_contents <<~HTML
      <span class="one">
        <div class="two">
          <br />
        </div>
      </span>
    HTML
  end
end
