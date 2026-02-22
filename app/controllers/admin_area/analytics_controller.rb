class AdminArea::AnalyticsController < ApplicationController
  before_action :require_admin_login

  def index
    # Filters
    @start_date = params[:start_date].presence
    @end_date = params[:end_date].presence
    @event_id = params[:event_id].presence
    @volunteer_id = params[:volunteer_id].presence

    # Top N (capped)
    requested_top_n = params[:top_n].to_i
    requested_top_n = 5 if requested_top_n <= 0
    @top_n = [[requested_top_n, 1].max, 50].min

    # Base scope: only completed assignments
    base_scope = VolunteerAssignment.completed.includes(:volunteer, :event)

    # Date range filter (by event_date)
    if @start_date.present?
      base_scope = base_scope.joins(:event).where("events.event_date >= ?", @start_date)
    end
    if @end_date.present?
      base_scope = base_scope.joins(:event).where("events.event_date <= ?", @end_date)
    end

    # Event filter
    if @event_id.present?
      base_scope = base_scope.where(event_id: @event_id)
    end

    # Volunteer filter (optional)
    if @volunteer_id.present?
      base_scope = base_scope.where(volunteer_id: @volunteer_id)
    end

    # 1) Volunteer Activity Summary
    @volunteer_stats = base_scope.group(:volunteer_id)
                                 .select("volunteer_id,
                                          COUNT(DISTINCT event_id) as event_count,
                                          SUM(COALESCE(hours_worked, 0)) as total_hours,
                                          AVG(COALESCE(hours_worked, 0)) as avg_hours")
                                 .includes(:volunteer)

    # 2) Event Participation Summary
    @event_stats = base_scope.group(:event_id)
                             .select("event_id,
                                      COUNT(DISTINCT volunteer_id) as volunteer_count,
                                      SUM(COALESCE(hours_worked, 0)) as total_hours,
                                      AVG(COALESCE(hours_worked, 0)) as avg_hours")
                             .includes(:event)

    # 3) Top Volunteers (Top N)
    @top_by_hours = @volunteer_stats.reorder("total_hours DESC").limit(@top_n)
    @top_by_events = @volunteer_stats.reorder("event_count DESC").limit(@top_n)

    # 4) Low participation
    overall_completed_volunteer_ids = VolunteerAssignment.completed.distinct.pluck(:volunteer_id)
    @inactive_volunteers_overall = Volunteer.where.not(id: overall_completed_volunteer_ids)

    in_scope_completed_volunteer_ids = base_scope.distinct.pluck(:volunteer_id)
    @inactive_volunteers_in_scope = Volunteer.where.not(id: in_scope_completed_volunteer_ids)

    # Dropdowns
    @events = Event.order(:title)
    @volunteers = Volunteer.order(:full_name)
  end
end