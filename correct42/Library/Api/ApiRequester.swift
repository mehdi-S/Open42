//
//  APIManager.swift
//  correct42
//
//  Created by larry on 26/04/2016.
//  Copyright © 2016 42. All rights reserved.
//
import Alamofire
import SwiftyJSON

/// Permit request something to API with the help of `ApiRouter` and `DataLoader`
class ApiRequester {
	
	// MARK: Singleton
	/// Static Instance of the ApiRequester
	static let sharedInstance = ApiRequester(dataLoader: DuoQuadraLoader())
	
	/**
	Give the singleton object of the ApiRequester
	
	```
	let apiRequester = ApiRequester.Shared()
	```
	
	- returns: `static let instance`
	*/
	static func Shared() -> ApiRequester
	{
		return (self.sharedInstance)
	}
	
	/**
	Protocole use to contact the API.
	*/
	var oAuthProtocol:DataLoader?
	
	// MARK: - Initializer
	/**
	Init with an Data loader to define what kind of domain you want
	to touch with connect and request credential.
	*/
	init(dataLoader:DataLoader){
		oAuthProtocol = dataLoader
	}
	
	// MARK: - Methods
	/**
	Send request to api server with an APIRouter inheritance Enum and execute callback.
	
	```
	let apiRequester = APIRequester(myApiLoader)
	apiRequester.requestApi(UserRouter.Me, success:
	{ (fileContent) in
	print(fileContent)
	}
	}) { (error) in
	print(error)
	}
	```
	
	- Parameters:
	- router: ApiRouter protocol. Give the url of the ressource.
	- success: CallBack execute if the request success.
	- failure: CallBack execute if the request fail.
	*/
	func request(
		router:ApiRouter,
		callback:((JSON?, NSError?)->Void)?
		){
		// Show activity indicator.
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		
		// Check if oAuthProtocol has been implement
		guard oAuthProtocol != nil else {
			print("No protocol implemented in ApiRequester().oAuthProtocol")
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			return
		}
		// get header or nothing
		if let hdrs = oAuthProtocol!.getHeadersFromProtocolAuthorizedOrRefreshAndRequest(router,
		                                                                                 didFail: callback,
		                                                                                 retry: {self.request(router, callback: callback)}) {
			// Make request
			Alamofire.request(
				router.method,
				"\(router.baseUrl)\(router.path)",
				parameters: router.parameters,
				encoding: .URL,
				headers: hdrs)
				.responseJSON { reply in
					if callback != nil {
						if let response = reply.response {
							if let jsonData = reply.result.value{
								let responseJSON = JSON(jsonData);
								if response.statusCode == 200 {
									callback!(responseJSON, nil)
								}
								else {
									callback!(responseJSON, NSError(domain: self.oAuthProtocol!.domain, code: response.statusCode, userInfo: ["message":self.errorMessageFromJSON(responseJSON)]))
								}
							} else {
								callback!(nil, NSError(domain: self.oAuthProtocol!.domain, code: response.statusCode, userInfo: ["message":"Server Problem"]))
							}
						} else {
							callback!(nil, NSError(domain: self.oAuthProtocol!.domain, code: -1009, userInfo: ["message":"No Connection"]))
						}
						UIApplication.sharedApplication().networkActivityIndicatorVisible = false
					}
			}
		}
		
	}
	
	/**
	Take a jsonData where you think you have an error explaination string and return the contained string.
	Case intercepted :
	- json["error_description"]
	- jsonData["error"]["message"]
	- jsonData["error"]
	- Returns: The contained error string or the json in stirng to see what happen wrong.
	*/
	private func errorMessageFromJSON(jsonData:JSON) -> String {
		if let errorDescription = jsonData["error_description"].string {
			return errorDescription
		} else if let errorMessage = jsonData["error"]["message"].string {
			return errorMessage
		}
		return ("Unknow case json Error : \(jsonData)")
	}
	
	/**
	Refresh the token of the oAuthprotocol implemented
	
	- Parameter callback: If error exist JSON will be nil. JSON return <#need Completion#>
	*/
	func RefreshToken(callback:((JSON?, NSError?)->Void)?){
		// Show activity indicator.
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		
		// Check if oAuthProtocol has been implement
		guard oAuthProtocol != nil else {
			print("No protocol implemented in ApiRequester().oAuthProtocol")
			return
		}
		
		oAuthProtocol?.refreshToken({ (json, error) in
			if let callbackNOpt = callback {
				callbackNOpt(json, error)
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
		})
		
	}
	
	/**
	Connect ApiRequester with api server.
	
	- Parameter view: View where oauth perform segue to the safariView.
	- Parameter onCompletion: Callback call at any completions. String enum case of `ErrorType` from *p2_oAuth2* library
	*/
	func connect(viewController:UIViewController?, onCompletion:(wasFailure: Bool, error: ErrorType?) -> Void) {
		// Show activity indicator.
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		
		// Check if oAuthProtocol has been implement
		guard oAuthProtocol != nil else {
			print("No protocol implemented in ApiRequester().oAuthProtocol")
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			return
		}
		
		oAuthProtocol!.authorize(viewController, callback: { (fail, error) in
			onCompletion(wasFailure: fail, error: error)
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
		})
	}
	
	/**
	Download a Picture from an ApiRouter inheritance Enum and execute callback.
	
	let apiRequester = = APIRequester(myApiLoader)
	apiRequester.downloadFile(LigandRouter.Representation("NAG"), success:
	{ (fileContent) in
	print(fileContent)
	}
	}) { (error) in
	print(error)
	}
	
	- Parameters:
	- router: ApiRouter protocol. Give the url of the ressource.
	- success: CallBack execute if the request success, take String for the content of the File.
	- failure: CallBack execute if the request fail.
	*/
	// TODO: Change to onCompletion
	func downloadImage(imageUrl:String, success:(UIImage)->Void, failure:(NSError)->Void){
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		Alamofire.request(.GET, imageUrl).response() {
			(_, _, data, _) in
			if let data = data{
				if let image = UIImage(data: data){
					success(image)
				} else {
					failure(NSError(domain: "Error on casting data to image", code: -1, userInfo: nil))
				}
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			} else {
				failure(NSError(domain: "Error on download image user", code: -1, userInfo: nil))
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
		}
	}
	
	// TODO: Add Token if need secure
	func uploadImage(router:ApiRouter, image:UIImage, onProgress: (percent:Double)->Void, onCompletion: (NSError?)->Void){
		//		manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/octet-stream"]
		//
		//
		//		let imageData: NSMutableData = NSMutableData.dataWithData(UIImageJPEGRepresentation(imageTest.image, 30));
		//
		//		Alamofire.upload(.POST, "http://localhost:8080/rest/service/upload?attachmentName=file.jpg",  imageData)
		//			.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
		//				println(totalBytesWritten)
		//			}
		//			.responseString { (request, response, JSON, error) in
		//				println(request)
		//				println(response)
		//				println(JSON)
		//		}
	}
	
	/**
	Download a file from an ApiRouter inheritance Enum and execute callback.
	
	let apiRequester = APIRequester(myApiLoader)
	apiRequester.downloadFile(LigandRouter.Representation("NAG"), success:
	{ (fileContent) in
	print(fileContent)
	}
	}) { (error) in
	print(error)
	}
	
	- Parameters:
	- router: ApiRouter protocol. Give the url of the ressource.
	- success: CallBack execute if the request success, take String for the content of the File.
	- failure: CallBack execute if the request fail.
	*/
	func downloadFile(router:ApiRouter, success:(String)->Void, failure:(NSError)->Void){
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		Alamofire.request(router.method, "\(router.baseUrl)\(router.path)\(router.parameters)").response() {
			(_, _, data, _) in
			if let data = data{
				let fileContent = String.init(data: data, encoding: NSUTF8StringEncoding)
				if let content = fileContent{
					success(content)
				} else {
					failure(NSError(domain: "File content is empty", code: -1, userInfo: nil))
				}
			} else {
				failure(NSError(domain: "Error on download file", code: -1, userInfo: nil))
			}
			UIApplication.sharedApplication().networkActivityIndicatorVisible = false
		}
	}
	
	/**
	Check if `oAuthProtocol` load is authorized or not.
	- Returns: True if authorized.
	*/
	func isAuthorized() -> Bool {
		if let oauth = oAuthProtocol {
			return oauth.isAuthorized()
		}
		return false
	}
	
	/**
	Check if `oAuthProtocol` load is authorized or not.
	- Returns: True if authorized.
	*/
	func handleUrl(url:NSURL){
		if let oauth = oAuthProtocol {
			oauth.handleRedirectURL(url)
		}
	}
	
	func tokenExpiration(){
		if let oauth = oAuthProtocol {
			oauth.tokenExpiration()
		}
	}
}

