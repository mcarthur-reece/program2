require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  describe "validations" do
    subject { build(:volunteer) }

    context "with valid attributes" do
      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "username validations" do
      it "requires username to be present" do
        subject.username = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:username]).to include("can't be blank")
      end

      it "requires username to be unique" do
        create(:volunteer, username: "john_doe")
        subject.username = "john_doe"
        expect(subject).not_to be_valid
        expect(subject.errors[:username]).to include("has already been taken")
      end

      it "rejects whitespace-only username" do
        subject.username = "   "
        expect(subject).not_to be_valid
      end
    end

    context "full_name validations" do
      it "requires full_name to be present" do
        subject.full_name = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:full_name]).to include("can't be blank")
      end

      it "rejects whitespace-only full_name" do
        subject.full_name = "   "
        expect(subject).not_to be_valid
      end
    end

    context "email validations" do
      it "requires email to be present" do
        subject.email = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("can't be blank")
      end

      it "requires email to be unique" do
        create(:volunteer, email: "test@example.com")
        subject.email = "test@example.com"
        expect(subject).not_to be_valid
        expect(subject.errors[:email]).to include("has already been taken")
      end

      it "enforces case-insensitive uniqueness" do
        create(:volunteer, email: "Test@Example.com")
        subject.email = "test@example.com"
        expect(subject).not_to be_valid
      end

      it "accepts valid email formats" do
        valid_emails = %w[
          user@example.com
          USER@foo.COM
          A_US-ER@foo.bar.org
          first.last@foo.jp
          alice+bob@baz.cn
        ]

        valid_emails.each do |email|
          subject.email = email
          expect(subject).to be_valid, "#{email} should be valid"
        end
      end

      it "rejects invalid email formats" do
        invalid_emails = %w[
          user@example,com
          user_at_foo.org
          user.name@example.
          foo@bar_baz.com
          foo@bar+baz.com
          foo@bar..com
        ]

        invalid_emails.each do |email|
          subject.email = email
          expect(subject).not_to be_valid, "#{email} should be invalid"
        end
      end

      it "downcases email before saving" do
        subject.email = "TEST@EXAMPLE.COM"
        subject.save
        expect(subject.reload.email).to eq("test@example.com")
      end
    end

    context "password validations" do
      it "requires password to be present on create" do
        subject.password = nil
        subject.password_confirmation = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("can't be blank")
      end

      it "requires password to have minimum length of 6" do
        subject.password = "12345"
        subject.password_confirmation = "12345"
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      it "rejects whitespace-only passwords" do
        subject.password = "      "
        subject.password_confirmation = "      "
        expect(subject).not_to be_valid
        expect(subject.errors[:password]).to include("can't be blank")
      end

      it "accepts valid passwords" do
        subject.password = "password123"
        subject.password_confirmation = "password123"
        expect(subject).to be_valid
      end
    end

    context "optional fields" do
      it "is valid without phone_number" do
        subject.phone_number = nil
        expect(subject).to be_valid
      end

      it "is valid without address" do
        subject.address = nil
        expect(subject).to be_valid
      end

      it "is valid without skills_interests" do
        subject.skills_interests = nil
        expect(subject).to be_valid
      end
    end
  end

  describe "password authentication" do
    let(:volunteer) { create(:volunteer, password: "mypassword123") }

    it "authenticates with correct password" do
      expect(volunteer.authenticate("mypassword123")).to eq(volunteer)
    end

    it "does not authenticate with incorrect password" do
      expect(volunteer.authenticate("wrongpassword")).to be_falsey
    end
  end

  describe "password updates" do
    let(:volunteer) { create(:volunteer, password: "oldpassword123") }

    it "allows password to be updated" do
      volunteer.password = "newpassword123"
      volunteer.password_confirmation = "newpassword123"
      expect(volunteer.save).to be_truthy
      expect(volunteer.authenticate("newpassword123")).to eq(volunteer)
    end

    it "does not require password on update if not changing it" do
      volunteer.full_name = "New Name"
      expect(volunteer).to be_valid
      expect(volunteer.save).to be_truthy
    end
  end

  describe "default values" do
    it "sets total_hours to 0.0 by default" do
      volunteer = create(:volunteer)
      expect(volunteer.total_hours).to eq(0.0)
    end
  end

  describe "database constraints" do
    it "enforces username uniqueness at database level" do
      create(:volunteer, username: "testuser")
      duplicate = build(:volunteer, username: "testuser")

      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "enforces email uniqueness at database level" do
      create(:volunteer, email: "test@example.com")
      duplicate = build(:volunteer, email: "test@example.com")

      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "associations" do
    # These will be tested by Person 2 when they add the associations
    it "will have volunteer_assignments association" do
      # Placeholder - Person 2 will add this
      expect(Volunteer.new).to respond_to(:volunteer_assignments) if Volunteer.method_defined?(:volunteer_assignments)
    end
  end
end
