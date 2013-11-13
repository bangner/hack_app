module HackAppControllerHelper
  def title(title)
    content_for(:title) { title }
  end
  def header_class(header_class)
    content_for(:header_class) { header_class }
  end
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
  def avatar_url(account, size)
    gravatar_id = Digest::MD5.hexdigest(account.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end
  def month_options
    months = [['-', '']]
    (1..12).each { |m| months << [Date::MONTHNAMES[m] + " (#{m})", m] }
    months
  end
  def year_options
    years = [['-', '']]
    (Time.now.year.to_i).upto(2023).to_a.each { |y| years << [y, y] }
    years
  end
  def tech_focuses
    ['Ruby', 'JavaScript', 'Java', 'iOS', 'Android', 'PHP', '.NET', 'Python', 'Data Science', 'UX Design']
  end
  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end
end
