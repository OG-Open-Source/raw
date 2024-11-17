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
      # 轉換 GitHub 風格的警告為 Just-the-docs 風格
      content.gsub!(/\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\]\n(.*?)(?=\n\n|\z)/m) do |match|
        type = $1.downcase
        text = $2.strip
        "\n> #{text}\n{: .#{type}}\n"
      end
      content
    end
  end
end 