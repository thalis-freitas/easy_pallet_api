class ProductImportService < ImportService
  require 'roo'

  private

  def process_file
    xlsx = Roo::Excelx.new(@file.path)

    (2..xlsx.last_row).each do |i|
      product_data = get_data(xlsx.row(1), xlsx.row(i))
      Product.create!(product_data)
    end
  end
end
