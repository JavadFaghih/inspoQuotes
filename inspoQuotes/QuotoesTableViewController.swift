//
//  ViewController.swift
//  inspoQuotes
//
//  Created by JavadFaghih on 1/14/1399 AP.
//  Copyright © 1399 AP JavadFaghih. All rights reserved.
//

import UIKit
import StoreKit


class QuotoesTableViewController: UITableViewController, SKPaymentTransactionObserver {
  
    

    let productID = "com.javadfaghih.inspoQuotes"
    
    
    
    var quotoesToShow = ["the greatest glory is not never falling, but in rising every time we fall. - Confocius",
    "all our dream can come true, if we have the courage to pursue them. -Walt Disney",
    "it does not importtant how slowly you go as long as you do you do not stop. - Goerge Adair",
    "success is not final, failor is not fatal, it is courage to continue that counts, - Winston Churchil",
    "hard ship often prepare ordinar people for an extra ordinary destiney. - C.S. Lewis"]
   
    
    let premiumQuotoes = ["Belive in your self. you braver than you think, more talented than you know, and capable of more than you imagine. - Roy T. Bennet",
    "I learn that Courage was not the absence of fear, but the triumph over it. the brave man does not who never feel afraid, but who was conquers that fear. - Nelson Mandela.",
    "there is only one thing that make a dream impossible to achieve, the fear of failure. - Paulo Cuelho",
    "its not whether you get knokted down, It's Whether you gets up. - Vince Lombardi",
    "your tue success in life begins only when you make the commitment to become excellent at what you are do. - Brain Tracy", "Belive in yourself take on your Challenges, di deep within yourself to conquers fears, never let anyone bring you down. you got to keep going. - Chantal Suther Land"]
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        SKPaymentQueue.default().add(self)
        
        if isPurscassed() {
            showPremiumQuotes()
        } else {
            
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurscassed() {
            return quotoesToShow.count
        } else {
            return quotoesToShow.count + 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotoesCell", for: indexPath)
    
        if indexPath.row < quotoesToShow.count {
        
        cell.textLabel?.text = quotoesToShow[indexPath.row]
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "get more quotes"
            cell.textLabel?.textColor = .blue
            cell.accessoryType = .disclosureIndicator
            
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotoesToShow.count {
            buyPremiumQuotes()
             
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
   
    
    //MARK: - In App Purchase Methods
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // User Payment Successful
            
                SKPaymentQueue.default().finishTransaction(transaction)
                
                UserDefaults.standard.set(true, forKey: productID)
                
                
                
                
                showPremiumQuotes()
                
                print("transaction Successful")
                
            } else if transaction.transactionState == .failed {
                // UserPayment Failed

                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed do to error: \(errorDescription)")

                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            else if transaction.transactionState == .restored {
                
                showPremiumQuotes()
                
                
                navigationItem.setRightBarButton(nil, animated: true)
                tableView.reloadData()
                
                
                
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }
             
            
        }
      }
    
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            // User can make Payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = "com.javadfaghih.inspoQuotes"
            SKPaymentQueue.default().add(paymentRequest)
            
        } else {
            //User can't make payments
            print("user can't make payments")
        }
    }
    
    func showPremiumQuotes() {
        quotoesToShow.append(contentsOf: premiumQuotoes)
        tableView.reloadData()
        
        
    }
    
    func isPurscassed() -> Bool {
        
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        
        if purchaseStatus {
            print("Previousely Purchased")
            return true
        } else {
            print("print never purchased")
            return false
        }
        
        
    }
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
       }
    
    
}

