//
//  NetworkManager.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 16.04.25.
//

import Foundation


//MARK: - Delegate protocol

protocol WebSocketDelegate: AnyObject {
    func didReceiveText(text: String) async throws(ApiError) -> SocketMessage?
}

//MARK: - Class

class NetworkManager2 {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var dispatchTimer: DispatchSourceTimer?
    weak var receiveDelegate: WebSocketDelegate?
    
    enum RequestMethod : String {
        case get = "GET"
        case post = "POST"
    }
    
    private let serverIP = "192.168.1.100:8000"//"192.168.1.102:8000"//"http://192.168.1.108:8000"
    
    func sendRequest<ApiData: Codable>(
        url: String,
        method: RequestMethod,
        requestData: ApiData?) async throws(ApiError) -> Data? {
            
            // config url with call
            let url = URL(string: "http://" + serverIP + url)!
        
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if method == .post {
                request.httpBody = try? JSONEncoder().encode(requestData)
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var (data, response) : (Data?, URLResponse?) = (nil, nil)
            
            do {
                (data, response) = try await URLSession.shared.data(for: request)
            } catch {
                throw .appError(.systemError(error))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    throw ApiError.serverError(.init(error: ApiError.ServerError.Errors(rawValue: response.statusCode) ?? .unknown))
                }
            }
            
            return data
    }
    
    struct EmptyRequest: Codable {
        
    }
    
    func sendDataSocket<ApiData: Encodable>(data: ApiData) async throws(ApiError) {
        if let socket = webSocketTask {
            var message : URLSessionWebSocketTask.Message?
            do {
                let jsonData = try JSONEncoder().encode(data)
                message = URLSessionWebSocketTask.Message.string(String(data: jsonData, encoding: .utf8) ?? "")
            } catch {
                throw .appError(.encoderError)
            }
            do {
                try await socket.send(message!)
            } catch {
                throw .serverError(.init(error: .socketError))
            }
        }
    }
    
    func connect(token: String, to domain: ApiURL) async throws {
        guard webSocketTask == nil else { return }
        let url = URL(string: "ws://\(serverIP)" + domain.rawValue + "\(token)")
        webSocketTask = URLSession.shared.webSocketTask(with: url!)
        webSocketTask?.resume()
        pingServer()
        while true {
            try await startListening()
        }
    }
    
    private func pingServer() {
        dispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        if let timer = dispatchTimer {
            timer.schedule(deadline: .now() + 10, repeating: .seconds(10))
            timer.setEventHandler { [weak self] in
                print("timer")
                self?.webSocketTask?.sendPing(pongReceiveHandler: { error in
                    print(error?.localizedDescription)
                })
            }
            timer.resume()
        }
    }
    
    func startListening() async {
        do {
            let message = try await webSocketTask?.receive()
            switch message {
            case .string(let text):
                print("Received string: \(text)")
                try await receiveDelegate?.didReceiveText(text: text)
            case .data(let data):
                print("Received data: \(data)")
            case .none:
                print("none")
            @unknown default:
                print("Received unknown message")
            }
        } catch {
            print("Receive error: \(error.localizedDescription)")
        }
    }

    
    
}
