

class DashboardData: Decodable {
    let code: Int
    let msg: String
    let accessToken: String
    let data: Dashboard
    
    private enum CodingKeys : String, CodingKey {
        case code = "Code"
        case msg = "Msg"
        case accessToken = "AccessToken"
        case data = "Data"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(Int.self, forKey: .code)
        msg = try container.decode(String.self, forKey: .msg)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        data = try container.decode(Dashboard.self, forKey: .data)
    }
}

class Dashboard: Decodable {
    let total: Int
    var userProfiles: [UserProfile]
    
    private enum CodingKeys : String, CodingKey {
        case total = "Total"
        case userProfiles = "UserProfile"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        userProfiles = try container.decode([UserProfile].self, forKey: .userProfiles)
    }
}

class UserProfile: Decodable {
    
    
    
    let profileImage: String
    let userId: Int
    let height: Double
    let bodyType: String
    let educationLevel: String
    let smoke: String
    let drink: String
    let ethnic: String
    let relationShip: String
    let hasKids: String
    let wantKids: String
    let seekingGender: String
    let age: Int
    let images: [Images]
    
    let prefBodyType: String
    let prefMaritalStatus: String
    let prefEducation: String
    let prefSmoking: String
    let prefDrinking: String
    let prefEthnicity: String
    let prefWantKids: String
    let prefReligion: String
    let distance: Double
    let prefHeightTo: Double
    let prefHeightFrom: Double
    let prefAgeTo: Int
    let prefAgeFrom: Int
    let percentage: Double
    var isLiked: Int
    let name: String
    let gender: String
    let city: String
    let state: String
    let about: String
    
    
    private enum CodingKeys : String, CodingKey {
        
        case name = "FullName"
        case gender = "Gender"
        case city = "City"
        case state = "State"
        case about = "About"
        case isLike = "IsLiked"
        case profileImage = "ProfileImage"
        case userId = "UserId"
        case height = "Height"
        case bodyType = "BodyType"
        case educationLevel = "EducationLevel"
        case smoke = "Smoke"
        case drink = "Drink"
        case ethnic = "Ethnic"
        case relationShip = "RelationShip"
        case hasKids = "HasKids"
        case wantKids = "WantKids"
        case seekingGender = "SeekingGender"
        case age = "Age"
        case images = "Images"
        
        case prefBodyType = "PreferredBodyType"
        case prefMaritalStatus = "PreferredMaritalStatus"
        case prefEducation = "PreferredEducation"
        case prefSmoking = "PreferredSmoking"
        case prefDrinking = "PreferredDrinking"
        case prefEthnicity = "PreferredEthnicity"
        case prefWantKids = "PreferredWantKids"
        case prefReligion = "PreferredReligion"
        case distance = "Distance"
        case prefHeightTo = "PreferredHeightTo"
        case prefHeightFrom = "PreferredHeightFrom"
        case prefAgeTo = "PreferredAgeTo"
        case prefAgeFrom = "PreferredAgeFrom"
        case percentage = "Percentage"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decode(String.self, forKey: .gender)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        about = try container.decode(String.self, forKey: .about)
        isLiked = try container.decode(Int.self, forKey: .isLike)
        profileImage = try container.decode(String.self, forKey: .profileImage)
        userId = try container.decode(Int.self, forKey: .userId)
        height = try container.decode(Double.self, forKey: .height)
        bodyType = try container.decode(String.self, forKey: .bodyType)
        educationLevel = try container.decode(String.self, forKey: .educationLevel)
        smoke = try container.decode(String.self, forKey: .smoke)
        drink = try container.decode(String.self, forKey: .drink)
        ethnic = try container.decode(String.self, forKey: .ethnic)
        relationShip = try container.decode(String.self, forKey: .relationShip)
        hasKids = try container.decode(String.self, forKey: .hasKids)
        wantKids = try container.decode(String.self, forKey: .wantKids)
        seekingGender = try container.decode(String.self, forKey: .seekingGender)
        age = try container.decode(Int.self, forKey: .age)
        images = try container.decode([Images].self, forKey: .images)
        
        prefBodyType = try container.decode(String.self, forKey: .prefBodyType)
        prefMaritalStatus = try container.decode(String.self, forKey: .prefMaritalStatus)
        prefEducation = try container.decode(String.self, forKey: .prefEducation)
        prefSmoking = try container.decode(String.self, forKey: .prefSmoking)
        prefDrinking = try container.decode(String.self, forKey: .prefDrinking)
        prefEthnicity = try container.decode(String.self, forKey: .prefEthnicity)
        prefWantKids = try container.decode(String.self, forKey: .prefWantKids)
        prefReligion = try container.decode(String.self, forKey: .prefReligion)
        distance = try container.decode(Double.self, forKey: .distance)
        prefHeightTo = try container.decode(Double.self, forKey: .prefHeightTo)
        prefHeightFrom = try container.decode(Double.self, forKey: .prefHeightFrom)
        prefAgeTo = try container.decode(Int.self, forKey: .prefAgeTo)
        prefAgeFrom = try container.decode(Int.self, forKey: .prefAgeFrom)
        percentage = try container.decode(Double.self, forKey: .percentage)
        
    }
}

class Images: Decodable {
    let id: Int
    let imageUrl: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "Id"
        case imageUrl = "Image"
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
}
