require 'kramdown'

class Generate
  def initialize opts={}
    @opts = opts
    @template = File.read "html/template.html"
    @template = File.read "html/template.html"
  end

  def generate
    run "mkdir -p public/pages"
    run "mkdir -p public/imgs"
    run "cp -r css public"
    run "cp -r js public"

    page_in_template "index.html"

    Dir["html/pages/*"].each do |page|
      page.gsub!("html/", "")
      page_in_template page
    end

    Dir["imgs/*"].each do |img|
      newimg = "public/" + img
      run "convert -scale 15% #{img} #{newimg}"
    end
  end

  def run cmd
    puts "$ #{cmd}"
    `#{cmd}`
  end

  def page_in_template src, dst=nil
    dst ||= src
    contents = File.read("html/" + src)

    final = Kramdown::Document.new(contents).to_html
    final = @template.gsub("{{content}}", final)
    final = final.gsub("{{navigation}}", navigation)

    File.write("public/#{dst}", final)
  end

  def navigation
    return @navigation if @navigation
    @navigation = ""
    Dir["html/pages/*"].each do |page|
      page = File.basename(page, ".html")
      pagename = page.gsub("_", " ").split.map(&:capitalize).join(" ")
      @navigation += %{
      <li class="">
        <a class="" href="pages/#{page}.html">#{pagename}</a>
      </li>
      }
    end
    @navigation
  end
end

Generate.new.generate
