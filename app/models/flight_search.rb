class FlightSearch

  extend ActiveModel::Naming
  
  attr_reader :from, :date, :period, :weeks
  attr_reader :errors, :origin, :results

  PERIODS = { "month" => 1, "season" => 3 }

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def self.find_by_cheapest(options)
    FlightSearch.new.find_cheapest(options)
  end

  def find_cheapest(options)
    @from = options[:from]
    @date = options[:date]
    @period = options[:period]
    @weeks = options[:weeks]
    
    return self unless validate!

    start_date = Date.parse(@date.to_s)

    @origin = find_origin @from
    
    if @origin.nil?
      errors.add(:from, "is not found")
      return self
    end

    end_date = start_date.months_since(PERIODS[@period])

    flightSlice = Flight.from_origin_in_period(origin, start_date, end_date)
    
    if !@weeks.nil? && @weeks.to_i > 0
      flightSlice = flightSlice.return_weeks(weeks)
    end

    # no subqueries support is available in arel
    # query is tested on mysql, may be not optimal elsewhere
    
    @results = flightSlice \
      .cheapest_by_destination \
      .includes(:destination) \
      .order(:value) \
      .all # fetch them now, do not count

    self
  end
  
  def read_attribute_for_validation(attr)
    send(attr)
  end
  
  def FlightSearch.human_attribute_name(attr, options = {})
    attr
  end
  
  def FlightSearch.lookup_ancestors
    [self]
  end

  def validate!
    errors.add(:from, "can't be empty") if @from.nil? || @from.blank?
    errors.add(:date, "can't be empty") if @date.blank? 
    begin
      @date.instance_of?(Date) || Date.parse(@date.to_s)
    rescue ArgumentError => e
      errors.add(:date, "is invalid")
    end
    errors.add(:period, "can't be empty") if @period.nil? 
    errors.add(:period, "is invalid") unless PERIODS.include? @period
    errors.add(:weeks, "is invalid") unless @weeks.nil? || @weeks.to_i >= 0
    errors.empty?
  end

  def as_json(options={})
    r = {}
    r[:errors] = errors unless errors.empty?
    r[:origin] = origin unless origin.blank?
    r[:results] = results unless results.nil?
    r
  end
  
  private

  def find_origin(origin_query)
    Airport.where(:code => origin_query).first || Airport.where("name LIKE ?", origin_query + '%').order(:name).first
  end

end
