module Jekyll
  class GitHubAlertsConverter < Converter
    priority :high
    
    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      content.gsub!(/>\s*\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]<br>\n>\s*(.*?)(?=\n\n|\n[^>]|\z)/m) do |match|
        type = $1.downcase
        text = $2.strip
        "> #{text}\n{: .#{type}}\n"
      end
      content
    end
  end
end 