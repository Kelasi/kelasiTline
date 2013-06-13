module ApplicationHelper

  def titleize(title_str)
    if title_str.present?
      " | #{title_str}"
    else
      ""
    end
  end
end
