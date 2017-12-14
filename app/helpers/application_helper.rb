module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "layouts.header.logo"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def size_list_request
    Friend.accepter(current_user.id).status_request(false).size
  end

  def size_list_pending
    Friend.sender(current_user.id).status_request(false).size
  end
end
