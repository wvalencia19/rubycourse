class Profile < ActiveRecord::Base
  belongs_to :user

  validate :name_validator
  validate :name_gender_validator

  validates :gender, inclusion: { in: %w(male female)}

  def name_validator
    if first_name == nil && last_name == nil
      errors.add(:first_name, "Cannot be both nil")
    end
  end

  def name_gender_validator
    if gender == 'male' && first_name == "Sue"
      errors.add(:first_name, "If gender is male, first_name can't starts with Sue")
    end
  end

  def self.get_all_profiles(min_birth_year, max_birth_year)
    self.where("birth_year BETWEEN :min_birth_year AND :max_birth_year", min_birth_year:min_birth_year, 
    max_birth_year:max_birth_year).order(:birth_year).to_a
  end
end
