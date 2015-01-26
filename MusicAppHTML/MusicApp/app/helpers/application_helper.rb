module ApplicationHelper

  def auth_token
    str = <<-HTML
      <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}">
      HTML
    str.html_safe
  end

  def ugly_lyrics(lyrics)

    working = lyrics.split("\n").map{|el| '♫' + " " + el}.join("\n")
    result = <<-HTML
            <pre>#{h(working)}</pre>
              HTML
    result.html_safe
  end

end
