class UserImportService < ImportService
  require 'roo'

  private

  def process_file
    xlsx = Roo::Excelx.new(@file.path)

    (2..xlsx.last_row).each do |i|
      user_data = get_data(xlsx.row(1), xlsx.row(i))
      User.create!(user_data)
    end
  end
end
