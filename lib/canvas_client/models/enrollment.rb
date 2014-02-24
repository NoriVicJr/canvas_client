class Canvas::Enrollment < Canvas::Model
  attribute :type, String
  attribute :course_id, Integer
  attribute :user_id, Integer
  attribute :enrollment_state, String
  
  def student?
    type == 'StudentEnrollment'
  end
  
  def base_url
    File.join 'courses', course_id.to_s, 'enrollments'
  end
  
  def create_params
    {
      enrollment: {
        type: type,
        user_id: user_id,
        enrollment_state: enrollment_state
      }
    }
  end
  
  def self.for_course(course)
    url = File.join course.resource_url, 'enrollments'
    raw_items = client.get url
    raw_items ? raw_items.map {|item| new(item) } : []
  end
  
  def self.add_student_to_course(student_id: nil, course_id: nil)
    model = new type: 'StudentEnrollment', 
                enrollment_state: 'active',
                course_id: course_id,
                user_id: student_id
    model.save
    model
  end
  
end