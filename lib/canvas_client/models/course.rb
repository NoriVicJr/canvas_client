class Canvas::Course < Canvas::Model
  attribute :sis_course_id, String
  attribute :name, String
  attribute :course_code, String
  attribute :workflow_state, String
  attribute :account_id, Integer
  attribute :start_at, Date
  attribute :end_at, Date
  attribute :offer, Boolean
  attribute :open_enrollment, Boolean
  attribute :self_enrollment, Boolean
  
  def enrollments
    @enrollments ||= Canvas::Enrollment.for_course(self)
  end
  
  def self.base_url
    'courses'
  end
  
  def create_url
    File.join 'accounts', client.account, 'courses'
  end
  
  def create_params
    {
      course: {
        sis_course_id: sis_course_id,
        name: name,
        course_code: course_code,
        start_at: start_at,
        end_at: end_at,
        offer: offer
      }
    }
  end
  
  def update_params
    create_params
  end
  
  def destroy
    client.delete(resource_url + '?event=delete') and freeze
  end
  
  def conclude
    client.delete(resource_url + '?event=conclude') and freeze
  end
  
  def open
    self.self_enrollment = true
    self.open_enrollment = true
    self.offer = true
    save
  end
  
  def close
    self.self_enrollment = false
    self.open_enrollment = false
    self.offer = false
    save
  end
  
end