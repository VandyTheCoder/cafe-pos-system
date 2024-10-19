class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy ]

  # GET /sales
  def index
    @grid = SalesGrid.new(grid_params) do |scope|
      scope.page(params[:page]).per(10)
    end
  end

  # GET /sales/1
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = generate_receipt
        send_data pdf.render, filename: "invoice_#{@sale.code}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales
  def create
    @sale = Sale.new(sale_params)

    if @sale.save
      redirect_to @sale, notice: "Sale was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sales/1
  def update
    if @sale.update(sale_params)
      redirect_to @sale, notice: "Sale was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sales/1
  def destroy
    @sale.destroy!
    redirect_to sales_url, notice: "Sale was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sale_params
      params.require(:sale).permit(:code, :status, :customer_name, :customer_phone_number, :note, :user_id)
    end

    def grid_params
      params.fetch(:sales_grid, {}).permit(
        :status,
        :code,
        :created_at_gt,
        :created_at_lt
      )
    end

    def generate_receipt
      Prawn::Document.new do |pdf|
        pdf.text "RECEIPT", align: :center, size: 24, style: :bold
        pdf.move_down 20

        # Shop details
        pdf.text "Cafe POS System", size: 14, style: :bold
        pdf.text "Phnom Penh, Cambodia", size: 12
        pdf.move_down 5
        pdf.text "Invoice: #{@sale.code}", size: 12, style: :bold
        pdf.text "Date: #{@sale.created_at.strftime('%d / %B / %Y')}", size: 12
        pdf.text "Cashier: #{@sale.user&.name}", size: 12
        pdf.text "Phone: 012 XXX XXX", size: 12
        pdf.move_down 20

        # Line items
        pdf.table(line_items_table, width: 500, position: :center, cell_style: { border_lines: [ :dotted ] }) do
          row(0).font_style = :bold
          row(0).align = :center
          row(0).border_lines = [ :dashed ]
          row(0).border_width = 2
          cells.padding = 8
        end
        pdf.move_down 20

        # Total price
        pdf.text "Price: $#{@sale.amount.round(2)}", size: 24, style: :bold, align: :center
        pdf.move_down 20
        pdf.text "Thank You!", align: :center, size: 20
      end
    end

    def line_items_table
      item_index = 0
      [ [ "No.", "Name", "Size", "Sugar", "Price" ] ] +
        @sale.product_sales.map do |product_sale|
          item_index += 1
          [ "#{item_index}.", product_sale.product_size.product.name, product_sale.product_size.size, "#{product_sale.sugar_level} %", "$#{product_sale.price.round(2)}" ]
        end
    end
end
