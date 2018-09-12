
class ViewController: UIViewController {
    
    let path = Bundle.main.path(forResource: "data", ofType: "plist")
    
    var dataArray = [[String: Any]]()
    var dataModel = DataModel()
    @IBOutlet weak var plistDataTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.rightBarButtonItem = addButton
        onCreateData()
        dataModel.saveData()
        dataModel.loadData()
        print("succeed!", dataModel.saveTrack[0].name)
        for object in dataModel.saveTrack{
            print(object.name)
        }
    }

    //create data
    func onCreateData(){
        dataModel.saveTrack.append(SavedTracks(name: "jack", location: "xxx"))
        dataModel.saveTrack.append(SavedTracks(name: "tom", location: "yyyy"))
        dataModel.saveTrack.append(SavedTracks(name: "rose", location: "zzz"))
    }
    
    @objc func handleAdd(){
        
        let alert = UIAlertController(title: "Enter Details", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Mobile"
            textField.keyboardType = .numberPad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.keyboardType = .default
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let nametextField = alert?.textFields![0].text
//            print("Name Text field: \(nametextField!.text)")
            
            let emailtextField = alert?.textFields![1].text
//            print("email Text field: \(emailtextField!.text)")
            
            let mobiletextField = alert?.textFields![2].text
//            print("mobile Text field: \(mobiletextField!.text)")
            
            let passwordtextField = alert?.textFields![3].text
//            print("password Text field: \(passwordtextField!.text)")
            self.onSubmit(name: nametextField!, email: emailtextField!, mobile: mobiletextField!, password: passwordtextField!)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    
    //Display Nation and Capital
    func displayNationAndCapitalCityNames() {
        
        if FileManager.default.fileExists(atPath: path!) {
            if let nationAndCapitalCitys = NSMutableArray(contentsOfFile: path!) {
                for object in nationAndCapitalCitys{
//                    if let objectData = object as? [String: Any]{
//                        print(objectData["email"]!)
//                    }
//                    dataArray.append(object as! [String : Any])
                    
                }
                print(dataArray)
                dataArray = nationAndCapitalCitys as! [[String : Any]]
                print(dataArray.count)
                plistDataTableView.reloadData()
            }
//            if let nationAndCapitalCitys = NSMutableDictionary(contentsOfFile: path!) {
//                for (_, element) in nationAndCapitalCitys.enumerated() {
//                    print(element.key,element.value)
//                }
//            }
        }
    }
    
    //On Click OF Submit
    func onSubmit(name: String, email: String, mobile: String, password: String) {
        if FileManager.default.fileExists(atPath: path!) {
            let nationAndCapitalCitys = NSMutableDictionary()
            nationAndCapitalCitys.setValue(password, forKey: "password")
            nationAndCapitalCitys.setValue(name, forKey: "name")
            nationAndCapitalCitys.setValue(email, forKey: "email")
            nationAndCapitalCitys.setValue(mobile, forKey: "mobile")
            
            var myArray = NSMutableArray()
            myArray.add(nationAndCapitalCitys)
            myArray.write(toFile: path!, atomically: true)
        }
        displayNationAndCapitalCityNames()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlistCell", for: indexPath) as! PlistCell
        cell.setupData(data: dataArray[indexPath.row])
        return cell
    }
}



class SavedTracks: NSObject,NSCoding {
    var name: String
    var location: String
    
    required init(name:String="", location:String="") {
        self.name = name
        self.location = location
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "Name") as? String ?? ""
        self.location = decoder.decodeObject(forKey: "location") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey:"Name")
        coder.encode(location, forKey:"location")
    }
}

class DataModel: NSObject {
    
    var saveTrack = [SavedTracks]()
    
    override init(){
        super.init()
        print("document file path：\(documentsDirectory())")
        print("Data file path：\(dataFilePath())")
    }
    
    //save data
    func saveData() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(saveTrack, forKey: "userList")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    //read data
    func loadData() {
        let path = self.dataFilePath()
        let defaultManager = FileManager()
        if defaultManager.fileExists(atPath: path) {
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            saveTrack = unarchiver.decodeObject(forKey: "userList") as! Array
            unarchiver.finishDecoding()
        }
    }
    
    func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    func dataFilePath ()->String{
        return self.documentsDirectory().appendingFormat("/data.plist")
    }
}


class MyViewController: UIViewController {
    var dataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onCreateData()
    }
    
    //create data
    func onCreateData(){
        dataModel.saveTrack.append(SavedTracks(name: "jack", location: "xxx"))
        dataModel.saveTrack.append(SavedTracks(name: "tom", location: "yyyy"))
        dataModel.saveTrack.append(SavedTracks(name: "rose", location: "zzz"))
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        dataModel.saveData()
        print("succeed")
    }
    
    @IBAction func printData(_ sender: UIButton) {
        dataModel.loadData()
        print("succeed!", dataModel.saveTrack)
    }
}
