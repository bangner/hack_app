module Media
  def upload_logo
    logo_io = params[:bootcamp][:logo]
    ext = File.extname(logo_io.original_filename)

    bootcamp_slug = params[:bootcamp][:name].parameterize

    # Create directory if it does not exist
    bootcamp_directory = Rails.root.join('public', 'uploads', 'bootcamps', bootcamp_slug).to_s
    Dir.mkdir(bootcamp_directory) unless File.exists?(bootcamp_directory)

    File.open(bootcamp_directory + '/logo' + ext, "wb") do |file|
      file.write(logo_io.read)
    end

    home_path + 'uploads/bootcamps/' + bootcamp_slug + '/logo' + ext
  end
end