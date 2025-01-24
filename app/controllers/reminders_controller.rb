class RemindersController < ApplicationController
  helper ReminderHelper
  before_action :set_reminder, only: %i[ destroy ]

  def index
    @reminders = Reminder.all.order(scheduled_at: :desc)
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.scheduled_at = parse_scheduled_at

    if @reminder.save
      redirect_to reminders_path, notice: "Reminder (#{@reminder.title}) was successfully created."
    else
      @reminder.scheduled_at = nil
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @reminder = Reminder.find(params[:id])
  end

  def update
    @reminder = Reminder.find(params[:id])

    if @reminder.update(**reminder_params, scheduled_at: parse_scheduled_at)
      redirect_to reminders_path, notice: "Reminder (#{@reminder.title}) was successfully created."
    else
      @reminder.scheduled_at = nil
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reminder.destroy!

    redirect_to reminders_path, notice: "Reminder (#{@reminder.title}) was successfully destroyed."
  end

  private

  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.require(:reminder).permit(
      :title,
      :description,
      :scheduled_at,
      :price,
      :currency,
      :frequency,
      :timezone
    )
  end

  def parse_scheduled_at
    zone = ActiveSupport::TimeZone[params[:reminder][:timezone] || Time.current.zone]
    zone.parse(params[:reminder][:scheduled_at]).utc.change(sec: 0)
  end
end
