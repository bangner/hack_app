module HackAppControllerHelper
  def active_page(path)
    "active" if current_page?(path)
  end
  def active_controller(controller)
    "active" if controller_path.eql? controller
  end
  def active_admin
    "active " if admin_namespace?
  end
  def admin_namespace?
    controller.class.name.split("::").first == "Admin"
  end
end
