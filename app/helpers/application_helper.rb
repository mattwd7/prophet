module ApplicationHelper

  def format_content(content)
    char_limit = 300
    if content.length > char_limit
      show = content.first(char_limit)
      hide = content.last(content.length - char_limit)
      "<span>#{show}</span><span class='show-more'>...#{link_to(' See More', '')}</span><span class='hidden'>#{hide}</span>".html_safe
    else
      simple_format(content)
    end
  end

end
