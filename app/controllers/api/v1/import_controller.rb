class Api::V1::ImportController < Api::V1::ApiController
  def users
    if validate_file_format(params[:file])
      import_user(params[:file])
    else
      render_invalid_file_format
    end
  end

  def products
    if validate_file_format(params[:file])
      import_products(params[:file])
    else
      render_invalid_file_format
    end
  end

  def loads
    if validate_file_format(params[:file])
      import_loads(params[:file])
    else
      render_invalid_file_format
    end
  end

  private

  def validate_file_format(file)
    file.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  end

  def render_invalid_file_format
    render json: { error: I18n.t('errors.import.invalid_file_format') },
           status: :unprocessable_entity
  end

  def import_user(file)
    UserImportService.new(file).call
    render status: :created
  rescue StandardError
    render_unexpected_error
  end

  def import_products(file)
    ProductImportService.new(file).call
    render status: :created
  rescue StandardError
    render_unexpected_error
  end

  def import_loads(file)
    xlsx = Roo::Excelx.new(file.path)
    sheet_name = xlsx.sheets.first
    headers = xlsx.sheet(sheet_name).row(1)
    header_mapping = create_header_mapping(headers)
    process_load_data(xlsx, sheet_name, header_mapping)
  end

  def create_header_mapping(headers)
    header_mapping = {}
    headers.each_with_index { |header, index| header_mapping[header] = index }
    header_mapping
  end

  # rubocop:disable Metrics/AbcSize
  def process_load_data(xlsx, sheet_name, header_mapping)
    (2..xlsx.last_row).each do |i|
      row = xlsx.sheet(sheet_name).row(i)
      load = find_or_create_load({ code: row[header_mapping['load_code']],
                                   delivery_date: row[header_mapping['delivery_date']] })
      order = find_or_create_order({ code: row[header_mapping['order_code']],
                                     bay: row[header_mapping['bay']], load: })
      product = find_or_create_product({ name: row[header_mapping['product']] })
      create_order_product({ order:, product:,
                             quantity: row[header_mapping['quantity']] })
    end
  end
  # rubocop:enable Metrics/AbcSize

  def find_or_create_load(load_data)
    Load.find_or_create_by(code: load_data[:code], delivery_date: load_data[:delivery_date].to_date)
  end

  def find_or_create_order(order_data)
    Order.find_or_create_by(code: order_data[:code], bay: order_data[:bay], load: order_data[:load])
  end

  def find_or_create_product(product_data)
    Product.find_or_create_by(name: product_data[:name])
  end

  def create_order_product(order_product_data)
    OrderProduct.create(order_product_data)
  end

  def render_unexpected_error
    render json: { error: I18n.t('errors.import.unexpected_error') },
           status: :unprocessable_entity
  end
end
