import Foundation
import Fluent
import Vapor

final class Teacher: Model {
    
    static let schema: String = "teachers"
    

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .firstName)
    var firstName: String
    
    @Field(key: .lastName)
    var lastName: String
    
    @Siblings(through: TeacherSubjectPivot.self, from: \.$teacher, to: \.$subject)
    var subjects: [Subject]
    
    init() {}
    
    init(id: UUID? = nil, firstName: String, lastName: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }

}

extension Teacher: Content {
    
    struct Public: Content {
        let firstName: String
        let lastName: String
        let id: UUID
    }
    
    func toPublicSubjects() throws -> [Subject.Public] {
        return try self.subjects.map { subject in
            try subject.toPublic()
        }
    }
    
    func toPublic() throws -> Public {
        return .init(firstName: self.firstName, lastName: self.lastName, id: try self.requireID())
    }
    
}



