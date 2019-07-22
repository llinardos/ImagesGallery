import Foundation
import Alamofire

extension DataRequest {
  public func response<T: DataResponseSerializerProtocol>(responseSerializer: T) -> DataResponse<T.SerializedObject> {
    let semaphore = DispatchSemaphore(value: 0)
    var result: DataResponse<T.SerializedObject>!
    
    self.response(queue: DispatchQueue.global(qos: .default), responseSerializer: responseSerializer) { response in
      result = response
      semaphore.signal()
    }
    
    _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    
    return result
  }
  
  public func responseJSON(options: JSONSerialization.ReadingOptions = .allowFragments) -> DataResponse<Any> {
    return response(responseSerializer: DataRequest.jsonResponseSerializer(options: options))
  }
}
