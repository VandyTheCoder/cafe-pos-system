class HomepageController < ApplicationController
  def index
    current_date = Date.today
    @vaid_filtered_months = (0..3).map { |i| current_date.prev_month(i) }
    @filtered_month = params[:month] ? params[:month] : Date.today.month.to_s
    @filtered_year = params[:year] ? params[:year] : Date.today.year.to_s
    get_this_month_and_previous_month_sales
    get_this_year_and_previous_year_sales
  end

  def chart_data
    filtered_month = params[:month] ? params[:month].to_i : Date.today.month
    filtered_year = params[:year] ? params[:year].to_i : Date.today.year

    # Generate a range of dates for the filtered month and year
    start_date = Date.new(filtered_year, filtered_month, 1)
    end_date = start_date.end_of_month
    date_range = (start_date..end_date).to_a

    # Get the total amount for each day where status is "Completed" for the current month, including today
    sales_data = Sale.where(status: "Completed")
                     .where("created_at >= ? AND created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
                     .group("DATE(created_at)")
                     .select("DATE(created_at) as date, SUM(amount) as total_amount")
                     .order("DATE(created_at) ASC")

    # Convert sales_data to a hash with dates as keys
    sales_hash = sales_data.each_with_object({}) do |sale, hash|
      hash[sale.date] = sale.total_amount
    end

    # Initialize arrays for dates and amounts
    dates = []
    amounts = []

    # Map the date range to the desired format, filling in 0 for dates with no sales
    date_range.each do |date|
      dates << date.strftime("%d")
      amounts << (sales_hash[date] ? sales_hash[date].round(2) : 0)
    end

    render json: {
      dates: dates,
      amounts: amounts,
      highest_amount: amounts.max,
      monthly_sales: get_monthly_sales,
      yearly_sales: get_yearly_sales,
      yearly_labels: (0..2).map { |i| Date.today.prev_year(i).year }
    }
  end

  private
    def get_monthly_sales
      current_date = Date.today
      months = (0..6).map { |i| current_date.prev_month(i) }.reverse
      amounts = []
      months.each do |date|
        start_date = date.beginning_of_month
        end_date = date.end_of_month
        total_amount = Sale.where(status: "Completed")
                          .where("created_at >= ? AND created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
                          .sum(:amount)
        amounts << total_amount.round(2)
      end
      amounts
    end

    def get_yearly_sales
      current_date = Date.today
      years = (0..2).map { |i| current_date.prev_year(i) }
      amounts = []
      total_amount = 0

      years.each do |date|
        start_date = date.beginning_of_year
        end_date = date.end_of_year
        total_amount_for_year = Sale.where(status: "Completed")
                                    .where("created_at >= ? AND created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
                                    .sum(:amount)
        amounts << total_amount_for_year.round(2)
        total_amount += total_amount_for_year
      end

      yearly_percentages = amounts.map do |amount|
        if total_amount > 0
          ((amount / total_amount.to_f) * 100).round(2)
        else
          0
        end
      end

      yearly_percentages
    end

    def get_this_month_and_previous_month_sales
      start_date = Date.today.beginning_of_month
      end_date = Date.today.end_of_month
      @total_amount_this_month = Sale.where(status: "Completed")
                                     .where("created_at >= ? AND created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
                                     .sum(:amount)

      previous_year_start_date = start_date.last_year
      previous_year_end_date = end_date.last_year
      total_amount_this_month_last_year = Sale.where(status: "Completed")
                                               .where("created_at >= ? AND created_at <= ?", previous_year_start_date.beginning_of_day, previous_year_end_date.end_of_day)
                                               .sum(:amount)

      if total_amount_this_month_last_year > 0
        @percentage_monthly_difference = ((@total_amount_this_month - total_amount_this_month_last_year) / total_amount_this_month_last_year.to_f) * 100
      else
        @percentage_monthly_difference = @total_amount_this_month > 0 ? 100 : 0
      end
      @is_monthly_positive = @total_amount_this_month > total_amount_this_month_last_year
    end

    def get_this_year_and_previous_year_sales
      start_date = Date.today.beginning_of_year
      end_date = Date.today.end_of_year
      @total_amount_this_year = Sale.where(status: "Completed")
                                  .where("created_at >= ? AND created_at <= ?", start_date.beginning_of_day, end_date.end_of_day)
                                  .sum(:amount)

      previous_year_start_date = start_date.last_year
      previous_year_end_date = end_date.last_year
      total_amount_this_year_last_year = Sale.where(status: "Completed")
                                          .where("created_at >= ? AND created_at <= ?", previous_year_start_date.beginning_of_day, previous_year_end_date.end_of_day)
                                          .sum(:amount)

      if total_amount_this_year_last_year > 0
        @percentage_yearly_difference = ((@total_amount_this_year - total_amount_this_year_last_year) / total_amount_this_year_last_year.to_f) * 100
      else
        @percentage_yearly_difference = @total_amount_this_year > 0 ? 100 : 0
      end
      @is_yearly_positive = @total_amount_this_year > total_amount_this_year_last_year
    end
end
