class Generate
  def initialize opts={}
    @opts = opts
    @template = File.read "html/template.html"
  end

  def generate
    run "mkdir -p public/cities"
    run "cp -r css public"
    run "cp -r js public"

    page_in_template "index.html"

    Dir["html/cities/*"].each do |city|
      city.gsub!("html/", "")
      page_in_template city
    end
  end

  def run cmd
    puts "$ #{cmd}"
    `#{cmd}`
  end

  def page_in_template src, dst=nil
    dst ||= src
    contents = File.read("html/" + src)
    File.write("public/#{dst}", @template.gsub("{{content}}", contents))
  end
end

Generate.new.generate
