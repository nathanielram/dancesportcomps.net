module ApplicationHelper

 	def title(title = nil)
    if title.present?
      content_for :title, title
    else
    	default_title = "Dancesport Competitions"
      content_for?(:title) ? "#{content_for(:title)} | #{default_title}" : default_title
    end
  end

 	def meta_description(desc = nil)
    if desc.present?
      content_for :meta_description, desc
    else
    	default_description = "List of global dancesport competitions. Helping you find your next competition!"
      content_for?(:meta_description) ? content_for(:meta_description) : default_description
    end
  end

end
