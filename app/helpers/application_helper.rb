module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title page_title = ""
    base_title = I18n.t "layouts.application.base_title"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  # Returns alert msg css class
  def alert_msg alert_type
    case alert_type
    when "success"
      "alert alert-success"
    when "danger"
      "alert alert-danger"
    when "error"
      "alert alert-error"
    else
      "alert"
    end
  end
end
