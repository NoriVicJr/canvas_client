require 'spec_helper'

describe Canvas::Enrollment do

  it 'adds a student to a course' do
    VCR.use_cassette('enroll_student_in_course') do
      enrollment = Canvas::Enrollment.add_student_to_course(student_id: 2, course_id: 2)
      enrollment.id.wont_be_nil
    end
  end

  it 'loads enrollments for course' do
    VCR.use_cassette('course enrollments') do
      course = Canvas::Course.find 2
      enrollments = Canvas::Enrollment.for_course(course)
      enrollments.wont_be_empty
    end
  end

  context '#url building' do
    it 'should know its base url' do
      enrollment = Canvas::Enrollment.new course_id: 42
      enrollment.base_url.must_equal 'courses/42/enrollments'
    end
    it 'should know its delete url' do
      enrollment = Canvas::Enrollment.new course_id: 42, id: 442
      enrollment.destroy_url.must_equal 'courses/42/enrollments/442'
    end
  end

end