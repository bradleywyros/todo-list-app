class Item < ApplicationRecord
  validates :title, :duedate, presence: true
  enum :status, { pending: "pending", in_progress: "in_progress", completed: "completed" }
  belongs_to :list

  scope :by_duedate, ->(duedate) { 
    where(duedate: Date.parse(duedate).beginning_of_day..Date.parse(duedate).end_of_day) if duedate.present?
  }
  scope :from_start_date, ->(start_date) { where('duedate >= ?', Date.parse(start_date).beginning_of_day) if start_date.present? }
  scope :by_end_date, ->(end_date) { where('duedate <= ?', Date.parse(end_date).end_of_day) if end_date.present? }
  scope :by_duedate_range, ->(start_date, end_date) { 
    where('duedate BETWEEN ? AND ?', Date.parse(start_date).beginning_of_day, Date.parse(end_date).end_of_day) if start_date.present? && end_date.present?
  }
  scope :by_status, ->(status) { where('status = ?', status) if status.present? }
  
end
