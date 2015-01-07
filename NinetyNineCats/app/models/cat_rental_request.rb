class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :no_overlapping_approved_requests?
  validate :start_date_after_today?
  validate :end_date_after_start_date?

  belongs_to :cat

  after_initialize { self.status ||= "PENDING" }

  def overlapping_requests
    CatRentalRequest.all.select do |request|
      self.cat_id == request.cat_id &&
        self.id != request.id &&
          (request.start_date.between?(start_date, end_date) ||
            request.end_date.between?(start_date, end_date))
    end
  end

  def overlapping_approved_requests
    overlapping_requests.select { |o_request| o_request.status == "APPROVED" }
  end

  def overlapping_pending_requests
    overlapping_requests.select { |o_request| o_request.status == "PENDING" }
  end

  def no_overlapping_approved_requests?
    if self.status == "APPROVED" && !overlapping_approved_requests.empty?
      errors[:approved_request] << "can't conflict with existing approved requests"
    end
  end

  def start_date_after_today?
    unless start_date > Date.today
      errors[:start_date] << "can't be in the past"
    end
  end

  def end_date_after_start_date?
    unless end_date > start_date
      errors[:end_date] << "can't be before the start date"
    end
  end

  def approve!
    begin
      CatRentalRequest.transaction do
        self.status = "APPROVED"
        self.save
        overlapping_pending_requests.each(&:deny!)
      end
    rescue
      false
    else
      true
    end
  end

  def deny!
    self.status = "DENIED"
    if self.save
      true
    else
      false
    end
  end
end
