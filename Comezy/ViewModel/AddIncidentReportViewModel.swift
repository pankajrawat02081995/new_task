//
//  AddIncidentReportViewModel.swift
//  Comezy
//
//  Created by aakarshit on 01/07/22.
//

import Foundation

class AddIncidentReportViewModel: NSObject {
    
    ///Variables
    var allPeopleSearchedListDataDetail = [AllPeopleListElement]()
    var allWitnessListDataDetail = [AllPeopleListElement]()

    var allPeopleListDataDetail = [AllPeopleListElement]()

    ///API Method of creating incident report
    func createIncidentReport(name:String,dateOfIncidentReported: String, dateOfIncident: String, typeOfIncident: Int, timeOfIncident: String, timeOfIncidentReported: String, descriptionOfIncident: String, preventiveActionTaken: String, personCompletingForm: Int, witnessOfIncident: Int, file: [String],project: Int, visitor_name: String, visitor_phone: String, completionHandler: @escaping(_ status: Bool, _ variationModel: AddIncidentReportModel?, _ errorMsg: String?) -> Void){
        
        //Request Body Parameter
        var parameters = [String : Any?]()
        if(witnessOfIncident == -1){
            parameters = [
                "name": name,
                "date_of_incident_reported": dateOfIncidentReported,
                "date_of_incident": dateOfIncident,
                "time_of_incident": timeOfIncident,
                "time_of_incident_reported": timeOfIncidentReported,
                "person_completing_form": personCompletingForm,
                "type_of_incident": typeOfIncident,
                "description_of_incident": descriptionOfIncident,
                "preventative_action_taken": preventiveActionTaken,
                "files": file,
                "project": project,
                "visitor_witness": visitor_name,
                "visitor_witness_phone":visitor_phone
            ]
        }else{
            parameters = [
                "name": name,
                "date_of_incident_reported": dateOfIncidentReported,
                "date_of_incident": dateOfIncident,
                "time_of_incident": timeOfIncident,
                "time_of_incident_reported": timeOfIncidentReported,
                "person_completing_form": personCompletingForm,
                "type_of_incident": typeOfIncident,
                "description_of_incident": descriptionOfIncident,
                "preventative_action_taken": preventiveActionTaken,
                "witness_of_incident": witnessOfIncident,
                "files": file,
                "project": project,
                "visitor_witness": "",
                "visitor_witness_phone":""
            ]
        }
        
        print("parameters @#$%@#$^%#^%#$%@", parameters)
        DispatchQueue.main.async{
            APIManager.shared.request(url: API.addIncidentReport, method: .post,parameters:parameters ,completionCallback: { (_ ) in
                
            }, success: {  (json) in
                print("json", json)
                if let json = json {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        let decodedData = try JSONDecoder().decode(BaseResponse<AddIncidentReportModel>.self, from: jsonData)
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
    //Validation Check
    func addIncidentReport(name:String,dateOfIncidentReported: String, dateOfIncident: String, typeOfIncident: Int?, timeOfIncident: String, timeOfIncidentReported: String, descriptionOfIncident: String, preventiveActionTaken: String, personCompletingForm: Int?, witnessOfIncident: Int?, witnessOfIncidentName: String?, file: [String],project: Int, visitor_witness_name:String, visitor_witness_phone:String  ,completionHandler:@escaping (_ sucess:Bool,_ eror:String?,_ type: String?) -> Void){
        if(name.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentReportName, "")
        }
        else if (dateOfIncidentReported.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentReportedDate,"")
        }
        else if (dateOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentDate,"")
        }
        else if (typeOfIncident == nil){
            completionHandler(false,FieldValidation.kIncidentType, "")
        }
        else if (timeOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentTime,"")
        }
        else if (descriptionOfIncident.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentDesc,"")
        }
        else if (preventiveActionTaken.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentPrevAct,"")
        }
        else if (dateOfIncidentReported.trimmingCharacters(in: .whitespaces).isEmpty){
            completionHandler(false,FieldValidation.kIncidentReportedDate,"")
        }
        else if (personCompletingForm == nil){
            completionHandler(false,FieldValidation.kIncidentPerCompleteForm, "")
        }
        else if (witnessOfIncident == -1) {
            completionHandler(false,FieldValidation.kIncidentSelecWitness, "")
        }
        else if (witnessOfIncidentName == "Other"){
            if(visitor_witness_name.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kIncidentVisitorWitnessName, "")
            }
            else if (visitor_witness_phone.trimmingCharacters(in: .whitespaces).isEmpty){
                completionHandler(false,FieldValidation.kIncidentVisitorWitnessPhone, "")
                
            }
            else if (visitor_witness_phone.trimmingCharacters(in: .whitespaces).isPhoneNumber){
                completionHandler(false,FieldValidation.kIncidentVisitorWitnessPhone, "")
                
            }
            
        }
        else {
            
            //API Method call of create incident report api
            self.createIncidentReport(name: name,dateOfIncidentReported: dateOfIncidentReported, dateOfIncident: dateOfIncident, typeOfIncident: typeOfIncident!, timeOfIncident: timeOfIncident, timeOfIncidentReported: timeOfIncidentReported, descriptionOfIncident: descriptionOfIncident, preventiveActionTaken: preventiveActionTaken, personCompletingForm: personCompletingForm!, witnessOfIncident: witnessOfIncident!, file: file, project: project,visitor_name: visitor_witness_name, visitor_phone: visitor_witness_phone) { success, response, message in
                if success {
                    completionHandler(true, nil, "")
                } else {
                    completionHandler(false,nil,FailureMessage.kErrorOccured)
                }
            }
        }
    }

    ///API Method of get Incident Type
    func getIncidentType(completionHandler: @escaping(_ status: Bool, _ listInfo: IncidentTypeModel?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getIncidentType
           
            APIManager.shared.requestWithoutHUD(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { (json) in
                
                if let json = json {
                    do {
                        print(json, "P R I N T     J S O N")
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let listInfo = try JSONDecoder().decode(BaseResponse<IncidentTypeModel>.self, from: jsonData)
                        print("listInfo  :", listInfo)
                        if listInfo.code == 200 {
                            let data = listInfo.data
                            completionHandler(true, listInfo.data, "")
                            
                        } else {
                            completionHandler(false,nil,listInfo.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
    
    ///API Method of Get All people list
    func getAllPeopleList(project_id: Int, completionHandler: @escaping(_ status: Bool, _ peopleList: [AllPeopleListElement]?, _ errorMsg: String?) -> Void) {
        
        DispatchQueue.main.async {

            var url = API.getAllPeopleList
            url = url + "\(project_id)"
            APIManager.shared.request(url: url, method: .get, parameters:nil ,completionCallback: { (_ ) in
                
            }, success: { [self] (json) in
                
                if let json = json {
                    do {
                        print(json)
                        let jsonData = try JSONSerialization.data(withJSONObject:json)
                        print("jsonData  :", jsonData)
                        let PeopleList = try JSONDecoder().decode(BaseResponse<AllPeopleListModel>.self, from: jsonData)
                        print("PeopleList  :", PeopleList)
                        if PeopleList.code == 200 {
                            self.allPeopleListDataDetail = PeopleList.data ?? []
                            completionHandler(true, self.allPeopleListDataDetail , "")
                            
                        } else {
                            completionHandler(false,nil,PeopleList.message ?? "")
                        }
                        
                    }
                    catch let err {
                        print(err)
                        print("ProjectList  err.localizedDescription:", err.localizedDescription)
                        completionHandler(false,nil,err.localizedDescription)
                    }
                }
            }) { (error) in
                print("ProjectList  error:", error)
                completionHandler(false,nil,error)
                
            }
        }
    }
}

