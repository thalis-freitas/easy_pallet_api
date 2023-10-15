class UserImportService
  require 'csv'
  require 'roo'

  def initialize(file)
    @file = file
  end

  def call
    if @file.content_type == 'text/csv'
      process_csv
    elsif @file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      process_xlsx
    end
  end

  private

  def process_csv
    CSV.foreach(@file.path, headers: true) do |row|
      User.create(name: row['name'], login: row['login'], password: row['password'])
    end
  end

  def process_xlsx
    xlsx = Roo::Excelx.new(@file.path)

    (2..xlsx.last_row).each do |i|
      user_data = user_data(xlsx.row(1), xlsx.row(i))
      User.create(user_data)
    end
  end

  def user_data(headers, row)
    data = {}

    headers.each_with_index do |column, i|
      column = column.to_s
      data[column] = row[i].is_a?(Float) ? row[i].to_i.to_s : row[i].to_s
    end

    data
  end
end
