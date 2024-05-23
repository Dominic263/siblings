import Vapor

struct TeacherStudentResponse: Content {
    let teacher: Teacher.Public
    let students: [Student.Public]
}

struct StudentTeacherResponse: Content {
    let student: Student.Public
    let teachers: [Teacher.Public]
}
