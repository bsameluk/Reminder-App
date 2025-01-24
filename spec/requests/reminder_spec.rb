# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Reminders", type: :request do
  describe "GET /index" do
    let!(:reminder1) do
      Reminder.create!(
        title: "First reminder",
        scheduled_at: 2.days.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::EACH_DAY,
        timezone: "UTC"
      )
    end

    let!(:reminder2) do
      Reminder.create!(
        title: "Second reminder",
        scheduled_at: 1.day.from_now,
        price: 199.99,
        currency: "EUR",
        frequency: Reminder::Frequencies::ONE_TIME,
        timezone: "UTC"
      )
    end

    it "returns http success and orders reminders by scheduled_at desc" do
      get reminders_path
      expect(response).to have_http_status(:success)
      expect(assigns(:reminders)).to eq([reminder1, reminder2])
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_reminder_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) do
      {
        reminder: {
          title: "Test reminder",
          scheduled_at: Time.current + 1.days,
          price: "99.99",
          currency: "USD",
          frequency: Reminder::Frequencies::ONE_TIME,
          timezone: "UTC"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new Reminder" do
        expect {
          post reminders_path, params: valid_attributes
        }.to change(Reminder, :count).by(1)
      end

      it "redirects to reminders index" do
        post reminders_path, params: valid_attributes
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          reminder: {
            title: "",  # title is required
            scheduled_at: Time.current + 1.days,
            price: "99.99",
            currency: "USD",
            frequency: Reminder::Frequencies::ONE_TIME,
            timezone: "UTC"
          }
        }
      end

      it "does not create a new Reminder" do
        expect {
          post reminders_path, params: invalid_attributes
        }.to change(Reminder, :count).by(0)
      end

      it "renders new template" do
        post reminders_path, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /edit" do
    let!(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::ONE_TIME,
        timezone: "UTC"
      )
    end

    it "returns http success" do
      get edit_reminder_path(reminder)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /update" do
    let!(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::ONE_TIME,
        timezone: "UTC"
      )
    end

    context "with valid parameters" do
      let(:new_attributes) do
        {
          reminder: {
            title: "Updated reminder",
            scheduled_at: Time.current + 1.days,
            price: "199.99",
            currency: "EUR",
            frequency: Reminder::Frequencies::EACH_DAY,
            timezone: "UTC"
          }
        }
      end

      it "updates the requested reminder" do
        patch reminder_path(reminder), params: new_attributes
        reminder.reload
        expect(reminder.title).to eq("Updated reminder")
        expect(reminder.price).to eq(199.99)
        expect(reminder.currency).to eq("EUR")
      end

      it "redirects to reminders index" do
        patch reminder_path(reminder), params: new_attributes
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) do
        {
          reminder: {
            title: "",  # title is required
            scheduled_at: Time.current + 1.days,
            price: "99.99",
            currency: "USD",
            frequency: Reminder::Frequencies::ONE_TIME,
            timezone: "UTC"
          }
        }
      end

      it "renders edit template" do
        patch reminder_path(reminder), params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:reminder) do
      Reminder.create!(
        title: "Test reminder",
        scheduled_at: 1.day.from_now,
        price: 99.99,
        currency: "USD",
        frequency: Reminder::Frequencies::ONE_TIME,
        timezone: "UTC"
      )
    end

    it "destroys the requested reminder" do
      expect {
        delete reminder_path(reminder)
      }.to change(Reminder, :count).by(-1)
    end

    it "redirects to reminders index" do
      delete reminder_path(reminder)
      expect(response).to redirect_to(reminders_path)
    end
  end
end
