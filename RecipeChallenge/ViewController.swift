//
//  ViewController.swift
//  RecipeChallenge
//
//  Created by Ishaq Amin on 24/06/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

// MARK: - WelcomeElement

struct WelcomeElement: Codable {
    let name: String
    let ingredients: [Ingredients]?
    }

struct Ingredients: Codable {
    let quantity: Int
    let name: String
    let type: String
}



//struct Ingredients: Codable {
//    let name: String?
//    let ingredients: [Ingredient]?
//    let steps: [String]?
//    let timers: [Int]?
//    let imageURL: String?
//    let originalURL: String?
//}

// MARK: - Ingredient
struct Ingredient: Codable {
    let quantity, name, type: String?
}

enum ApiError: Error {
    case noDataError
}

import UIKit

class ViewController: UIViewController {
    
    let url = "http://mobile.asosservices.com/sampleapifortest/recipes.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecipeJSON{ [weak self] (res) in DispatchQueue.main.async {
            switch res {
            case .success(let WelcomeElement):
                print("Recipe:",(WelcomeElement.name))
            case .failure(let err):
                print("No recipe for you, wasteman.")
            }
            }}
    }
    
    
    fileprivate func fetchRecipeJSON(completion: @escaping (Result<WelcomeElement, Error>) -> ()) {
        
        guard let url = URL(string: url) else {return}
        print(url)
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with:url) {
            (data, response, error) in
            if let err = error {
                completion(.failure(err))
                print(" It most likely comes here, duh")
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noDataError))
                print("Or does it come here?")
                return
            }
            
            do {
                let recipes = try! JSONDecoder().decode(WelcomeElement.self, from: data)
                completion(.success(recipes))
                print("Comes to here")
            }   catch let jsonError {
                completion(.failure(jsonError))
                print("No, it comes to here.")
            }
            
        } .resume()
        
        
    }
    
}
