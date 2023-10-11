//
//  EditIncidentReportViewModel.swift
//  Comezy
//
//  Created by aakarshit on 02/07/22.
//

import Foundation
class EditIncidentReportViewModel: NSObject {
    func putIncident(name:String,dateOfIncidentReported: String, dateOfIncident: String, timeOfIncident: String, timeOfIncidentReported: String, descriptionOfIncident: String, preventiveActionTaken: String, file: [String?],incidentId: Int, completionHandler: @escaping(_ status: Bool, _ variationModel: EditIncidentReportModel?, _ errorMsg: String?) -> Void){
        
        
        var parameters = [String : Any]()
        parameters = [
            "name": name,
            "date_of_incident_reported": dateOfIncidentReported,
            "date_of_incident": dateOfIncident,
            "time_of_incident": timeOfIncident,
            "time_of_incident_reported": timeOfIncidentReported,
            "description_of_incident": descriptionOfIncident,
            "preventative_action_taken": preventiveActionTaken,
            "files": file,
           
        ]
        let url = API.editIncident + "\(incidentId)"
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: url, method: .put ,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<EditIncidentReportModel>.self, from: jsonData)
                        print(decodedData)
                        if decodedData.code == 200 {
                            completionHandler(true, decodedData.data!, "")
                        } else {
                            completionHandler(false, nil ,decodedData.message ?? "")
                        }
                        
                    }
                    catch let err {
                        completionHandler(false,nil,err.localizedDescription ?? "")
                    }
                }
            }) { (error) in
                print("json error", error)
                completionHandler(false,nil,error)
            }
            
        }
        
    }
    func editIncident(name:String,dateOfIncidentReported: String, dateOfIncident: String, timeOfIncident: String, timeOfIncidentReported: String, descriptionOfIncident: String, preventiveActionTaken: String, file: [String?],project: Int,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter a name", "")
        }
        else if (dateOfIncidentReported.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter date of incident Reported","")
        }
        else if (dateOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter date of Incident","")
        }
//        else if (typeOfIncident == nil){
//            completionHandler(false,"Please select type of incident", "")
//        }
        else if (timeOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter time of incident","")
        }
        else if (descriptionOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter description of incident","")
        }
        else if (preventiveActionTaken.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter prevetive action taken","")
        }
        else if (dateOfIncidentReported.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,"Please enter date of incident reported","")
        }
//        else if (personCompletingForm == nil){
//            completionHandler(false,"Please select person completing form", "")
//        }
//        else if (witnessOfIncident == nil) {
//            completionHandler(false,"Please select witness of incident", "")
//        }
        else {
            
            self.putIncident(name: name,dateOfIncidentReported: dateOfIncidentReported, dateOfIncident: dateOfIncident, timeOfIncident: timeOfIncident, timeOfIncidentReported: timeOfIncidentReported, descriptionOfIncident: descriptionOfIncident, preventiveActionTaken: preventiveActionTaken, file: file, incidentId: project) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil, "An error occured!")
                }
            }
        }
    }
}
